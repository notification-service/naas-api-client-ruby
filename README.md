# NAAS API Client

This is the official `ruby` API Client

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'naas-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install naas-client

## Usage

The client is broken down into several concerns:

* [Configuration](#configuration): This provides the ability to set some defaults or configure as needed per-request.
* [Routing](#routing): By using the **API Directory**, we can show all available routes.
* [Logging](#logging): Setting up several log specifications for use with the client.
* [Connection](#connection): This is the main HTTP/TCP connection to the underlying service.
* [Requests](#requests): These are the raw _requests_ from the API service.
* Responses: These are the raw _responses_ form the API service request.
* Modeling: These are the domain models wrapped around the _response_ from the API service.
* Utilities: Helper tools to manage the end-to-end flow

### Tasks
There are some helpful tasks to get started:

#### YARD Documentation
This will build the YARD documentation for developers to review as they work on the client.

```ruby
bundle exec rake yard
```
Once this is completed, you can start the YARD server with:

```ruby
bundle exec yard server
```

And then open in your browser: http://localhost:8808

#### Routes
This will output all of the available _routes_ that are broadcast from the API service. It will return their name, URL, and Link Relationship.

```ruby
bundle exec rake routes
```

This is helpful as you need to issue or debug requests. It's also used throughout the client. One of the standards of the client is that you should **never have to manually construct a URL**. By using the directory and URI Templates we can approach this in a clean fashion.

> [See Routing Documentation Below](#routing)

## Configuration
The configuration can happen per instance or at a global level per application. This permits us to use with a single `access_token` in another context, or to use multiple clients.

Here is an example from a Demo Application (`/config/initializers/naas.rb`):

```ruby
require 'naas/client'

Naas::Client.configure do |config|
  config.api_host       = ENV.fetch('NAAS_API_HOST')
  config.access_token   = ENV.fetch('NAAS_ACCESS_TOKEN')
  config.media_type     = ENV.fetch('NAAS_MEDIA_TYPE')
  config.logger         = Rails.logger
  config.request_logger = Logger.new(File.expand_path('log/naas_requests.log', Rails.root))
end
```

You can review the configuration code to see what options are available and what _sensible defaults_ are used.

## Routing
Routing is handle by reading the Directory from the API Service. This returns all fully qualified URIs and [URI Templates](https://tools.ietf.org/html/rfc6570). By keeping the routing management in a single place, we eliminate the need to manually construct URIs with string building or string interpolation. Some examples:

```ruby
# Return a collection of all of the available routes
>> routes = Naas::Client.routes
=> #<Naas::Models::Links:0x00007f866721cf60>

# Find a route by the specified Link Relationship
>> route = routes.find_by_rel('http://api.dev.naas.com/rels/projects')
=> #<Naas::Models::Link:0x00007f86668eb1a8 @attributes={"name"=>"Projects", "href"=>"http://api.dev.naas.com/projects{?page,per_page}", "rel"=>"http://api.dev.naas.com/rels/projects", "templated"=>true}>

# Return the URL 
>> route.url_for
=> "http://api.dev.naas.com/projects"

# Check if the route is templated
>> route.templated?
=> true

# Return the URL with provided params
>> route.url_for(page: 1, per_page: 50)
=> "http://api.dev.naas.com/projects?page=1&per_page=50"
```

By using _named routes_ (`rel`) we reduce the risk that URIs change with the API Service. We only ever need to know the `rel` and the underlying API Service will manage what that points to.

## Logging
As the client may be used in different contexts, this permits us to use our customized `Logger` and log to different contexts (`Rails.logger`, `STDOUT`, etc). There are several logs that can be specified:

* `request_logger`: This will log all of the raw HTTP requests. The underlying HTTP dependency uses `Faraday` and these are the logs that our output from these requests.
* `logger`: This is where all activity is logged within the `gem` itself
* `cache_logger`: When enabled and supported, this is where caching would log the _hits_ and _misses_.

You may choose to point them all to the same log or have separate logs. The goal is to keep the separation of logging concerns.

## Connection
This is the main connection to the remote API Service. This is a `delegate` (wrapper) to the [`Faraday`](https://github.com/lostisland/faraday) HTTP Client Library. This connection will be set using the options specified in the [configuration](#configuration).

```ruby
# Return the HTTP connection to the service
>> Naas::Client.connection
=> #<Faraday::Connection:0x00007fa33f0a5908 @parallel_manager=nil, @headers={"User-Agent"=>"NAAS Ruby Gem 0.0.1", "Authorization"=>"Bearer 2b39f471c2eca67626928d5a906df629b7d13c700b74f264086ff0ae8f03", "Accept"=>"application/json", "Content-Type"=>"application/json"}, @params={}, @options=#<Faraday::RequestOptions (empty)>, @ssl=#<Faraday::SSLOptions (empty)>, @default_parallel_manager=nil, @builder=#<Faraday::RackBuilder:0x00007fa33f0a5228 @handlers=[FaradayMiddleware::ParseJson, Faraday::Response::Logger, Faraday::Adapter::NetHttp]>, @url_prefix=#<URI::HTTP http://api.dev.naas.com/>, @manual_proxy=false, @proxy=nil, @temp_proxy=nil>
```

## Requests
This is where HTTP requests get issued by the [specified connection](#connection). There are several things to note here:

* Not all requests will be returning `JSON` domain models. This means it may be more important to get the raw _response_ to work with the `body` or `headers.
* Some requests support pagination, and you can use the built-in tools of the client to _follow_ links. For example, you can use the client to **auto paginate** by following the `links` with a `rel` of `next` until none exists.
* You should be aware of the possible HTTP status code responses. The client provides a utility to map specific codes, named ranges, or a specific code itself.
* There are helper methods directly off of the `Client` itself to perform the basic operations.

Here are some examples:

```ruby
# Make a request to the admin (response truncated for brevity)
>> Naas::Client.get('/admin')
=> #<Faraday::Response:0x00007fee1a1d56e0>

# Make a head request
>> Naas::Client.head('/admin')
=> #<Faraday::Response:0x00007fee1a1d56e0>

# Make a post request
>> Naas::Client.post('/admin', MultiJson.dump('{}'))
=> #<Faraday::Response:0x00007fee1a1d56e0>

# Make a put request
>> Naas::Client.put('/admin', MultiJson.dump('{}'))
=> #<Faraday::Response:0x00007fee1a1d56e0>

# Make an options request
>> Naas::Client.options('/admin')
=> #<Faraday::Response:0x00007fee1a1d56e0>

# Make a delete request
>> Naas::Client.delete('/admin')
=> #<Faraday::Response:0x00007fee1a1d56e0>
```

You can also use a block with the `connection`:

```ruby
>> request = Naas::Client.connection.get do |req|
	req.url('/')
	req.headers['Accept'] = 'application/vnd.naas.json; version=1'
end
=> #<Faraday::Response:0x00007fee1a21db20?
```

There are also specific `Request` objects based on the **domain models**

```ruby
# Retrieve the owned Account
>> Naas::Requests::Accounts.retrieve
=> #<Faraday::Response:0x00007fee1aa571b0>

# Create a new Account SMTP record
>> Naas::Requests::AccountSmtpSettings.create(name: 'Gmail')
=> #<Faraday::Response:0x00007fee1a283308>
```


## Contributing

1. Fork it ( https://github.com/quicksprout/naas-api-client-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
