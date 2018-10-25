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

## Design Notes
An API client should be a composable object that provides both flexibility (advanced) and ease of use (novice).

* It keeps concerns separated.
* It can be used locally without the need for a connection. I may cache some responses and need to test with the JSON responses on disk. With the modeling not being bound to an HTTP connection, I can feed my JSON into the models and interact as if it had received the response from the HTTP connection.
* It captures dependency errors in a way that it always returns consistent errors to the client. A consumer of this utility should not have to concern themselves with underlying dependencies and have to know all possible exception states. Exceptions should be localized, while also providing a detailed stack trace.
* URIs should never be manually constructed. Once you receive the directory route you can get the rest from there. You can also cache the `routes` to use offline if needing to test against a specific link.
* The modeling should be explicit. As a developer I should be able to `grep` the codebase and work with the underlying code. There are many good use cases for meta-programming, but ultimately this should not hide the details that need to be visible. Principle of least surprise.

## Usage

The client is broken down into several concerns:

* [Configuration](#configuration): This provides the ability to set some defaults or configure as needed per-request.
* [Routing](#routing): By using the **API Directory**, we can show all available routes.
* [Logging](#logging): Setting up several log specifications for use with the client.
* [Connection](#connection): This is the main HTTP/TCP connection to the underlying service.
* [Requests](#requests): These are the raw _requests_ from the API service.
* [Responses](#responses): These are the raw _responses_ form the API service request.
* [Error Handling](#error-handling): These are all of the errors and exceptions that could be encountered.
* [Modeling](#modeling): These are the domain models wrapped around the _response_ from the API service.
* [Utilities](#utilities): Helper tools to manage the end-to-end flow

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

## Responses
These are the wrapped HTTP responses from the [requests](#requests). This object is a `delegate` to the `Faraday::Response` object and adds some additional helper utilities to manage the response. 

Examples

```ruby
# List out the projects
>> request = Naas::Requests::Projects.list
=> #<Faraday::Response:0x00007fee1a283308>

# Wrap in our Response object
>> response = Naas::Response.new(request)
=> #<Faraday::Response:0x00007f905326afa8>

# Return the ALLOW header
>> response.allow_header
=> 'get,post'

# Return the allowed methods
>> response.allowed_methods
=> ['GET', 'POST']

# See if the HTTP method is allowed
>> response.allowed?('GET')
=> true

# Use the `on` block to perform operations based on the status map
>> response.on(:success) { |resp| puts resp.body }
{"links"=>[{"name"=>"Campaigns", "href"=>"http://api.dev.naas.com/campaigns{?page,per_page}", "rel"=>"self", "templated"=>true}], "pagination"=>{"page"=>1, "per_page"=>10, "total"=>2, "maximum"=>250}, "data"=>[{"id"=>3, "project_id"=>1, "name"=>"Onboarding", "description"=>"Emails sent through onboarding.", "created_at"=>"2018-10-11T17:28:42Z", "updated_at"=>"2018-10-11T17:29:14Z", "links"=>[{"name"=>"Detail", "href"=>"http://api.dev.naas.com/campaigns/3", "rel"=>"self", "templated"=>false}, {"name"=>"Project", "href"=>"http://api.dev.naas.com/projects/1", "rel"=>"http://api.dev.naas.com/rels/project", "templated"=>false}, {"name"=>"Campaign Email Templates", "href"=>"http://api.dev.naas.com/campaigns/3/email-templates", "rel"=>"http://api.dev.naas.com/rels/campaign-campaign-email-templates", "templated"=>false}]}, {"id"=>1, "project_id"=>1, "name"=>"System Transactional Emails", "description"=>"All transactional systems sent by the Web Application", "created_at"=>"2018-09-13T12:47:23Z", "updated_at"=>"2018-10-11T17:25:09Z", "links"=>[{"name"=>"Detail", "href"=>"http://api.dev.naas.com/campaigns/1", "rel"=>"self", "templated"=>false}, {"name"=>"Project", "href"=>"http://api.dev.naas.com/projects/1", "rel"=>"http://api.dev.naas.com/rels/project", "templated"=>false}, {"name"=>"Campaign Email Templates", "href"=>"http://api.dev.naas.com/campaigns/1/email-templates", "rel"=>"http://api.dev.naas.com/rels/campaign-campaign-email-templates", "templated"=>false}]}]}
=> nil

# Create a block to handle a server error. In this case we have none
>> response.on(:server_error) { |resp| puts resp.body }
=> nil
```

The status map that is used with `on` includes:

* `failure`: Anything in the 400-499 range
* `redirect`: Anything in the 300-399 range
* `success`: Anything in the 200-299 range
* `server_error`: Anything in the 500-599 range

By supporting these _blocks_ we can capture server errors and send them to tools like Sentry for notifications and handling. This also allows us to get detailed responses in the case of errors to report to the developers of the API Service.

## Error Handling
Things can go wrong. We want to ensure a consistent fashion for handling:

* HTTP errors from the API Service
* Exceptions from our library or underlying dependencies

By doing so we can ensure the consumer of this client library will not have to know about underlying dependencies or issues. We can also use this to raise custom exceptions and `Error` objects within the library. An example is:

```ruby
# Try and retrieve a record that does not exist. We want this to raise an exception instead of handling ourselves.
>> account_smtp_setting = Naas::Requests::AccountSmtpSettings.retrieve!(200)
=> Naas::Errors::RecordNotFoundError ({"status"=>404, "message"=>"Not Found", "errors"=>[]})
>> 
```

## Modeling
These are the domain models that represent the `body` from the [request](#requests). We may support different models depending on the serialization (`JSON`, `CSV`, `PNG`, etc). 

> Currently we only support JSON domain models

Every object that has a response has a corresponding model:

* `Links`: This is a collection of `Link` objects. Wherever there is embedded hypermdia, this will be returned. Links can also be extracted from the `Link` HTTP header.
* `Pagination`: This is the object that corresponds to any pagination information on _lists_ of data. It gives the upper and lower bounds as well as total amount.
* `Data`: This is the main object that will correspond to a _list_ (collection) or _instance_ of an object. These models then support extended modeling.
* `Error`: This is the object that will return `ErrorItems` (collection) and `ErrorItem` (instance) records when an HTTP error occurs. This model is always the same.
* `Query`: This will support the query that gets sent to the server when performing a _search_. This will echo back the Query specified, based on the supported HTTP parameters

> Query is not yet supported

These models return the type-casted values of the attributes (`Boolean`, `DateTime`, `Date`, `Time`, `String`, `Integer`, etc).

Some examples:

```ruby
# Retrieve all Account SMTP settings and return only the `data` model
>> account_smtp_settings = Naas::Models::AccountSmtpSettings.list
=> #<Naas::Models::AccountSmtpSettings:0x00007ffc411c8d98 @collection=[{"id"=>2, "name"=>"Gmail", "description"=>"Send with domain gmail", "user_name"=>"nateklaiber@gmail.com", "address"=>"smtp.gmail.com", "domain"=>"naas-api.deviceindependent.com", "port"=>"587", "authentication_type_value"=>"plain", "is_starttls_auto_enabled"=>true, "is_primary"=>false, "created_at"=>"2018-10-04T15:02:42Z", "updated_at"=>"2018-10-04T15:02:42Z", "links"=>[{"name"=>"Detail", "href"=>"http://api.dev.naas.com/smtp-settings/2", "rel"=>"self", "templated"=>false}]}, {"id"=>1, "name"=>"SendGrid", "description"=>"Main domain send grid", "user_name"=>"apikey", "address"=>"smtp.sendgrid.net", "domain"=>"http://naas-api.deviceindependent.com", "port"=>"587", "authentication_type_value"=>"plain", "is_starttls_auto_enabled"=>true, "is_primary"=>true, "created_at"=>"2018-10-04T15:02:30Z", "updated_at"=>"2018-10-04T15:02:51Z", "links"=>[{"name"=>"Detail", "href"=>"http://api.dev.naas.com/smtp-settings/1", "rel"=>"self", "templated"=>false}]}]>

>> account_smtp_settings.count
=> 2

# Retrieve an Account SMTP setting with the specified ID
>> account_smtp_setting = Naas::Models::AccountSmtpSettings.retrieve(2)
=> #<Naas::Models::AccountSmtpSetting:0x00007ffc3f9fce30 @attributes={"id"=>2, "name"=>"Gmail", "description"=>"Send with domain gmail", "user_name"=>"nateklaiber@gmail.com", "address"=>"smtp.gmail.com", "domain"=>"naas-api.deviceindependent.com", "port"=>"587", "authentication_type_value"=>"plain", "is_starttls_auto_enabled"=>true, "is_primary"=>false, "created_at"=>"2018-10-04T15:02:42Z", "updated_at"=>"2018-10-04T15:02:42Z", "links"=>[{"name"=>"Detail", "href"=>"http://api.dev.naas.com/smtp-settings/2", "rel"=>"self", "templated"=>false}]}>

>> account_smtp_setting.name
=> "Gmail"
>> account_smtp_setting.description
=> "Send with domain gmail"
>> account_smtp_setting.primary?
=> false
>> account_smtp_setting.created_at
=> #<DateTime: 2018-10-04T15:02:42+00:00 ((2458396j,54162s,0n),+0s,2299161j)>
```

## Utilities
There are some utilities that can be injected in the client to assist in extended _syntactic sugar_. The primary example here is the `StatusCodeMapper` that permits us to perform actions on:

* An instance of a HTTP response code
* A collection of HTTP response codes
* A named range (`failure`, `redirect`, `success`, `server_error`)

This block will be available for all specified states and it's possible to use a mixture of the above.




## Contributing

1. Fork it ( https://github.com/quicksprout/naas-api-client-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
