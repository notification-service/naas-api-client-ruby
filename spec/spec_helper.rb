# http://www.relaxdiego.com/2013/06/mocking-web-services-with-vcr.html

require 'webmock/rspec'

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

require 'naas/client'

RSpec.configure do |config|
  config.after(:suite) do
    WebMock.disable!
  end
end
