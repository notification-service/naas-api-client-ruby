# http://www.relaxdiego.com/2013/06/mocking-web-services-with-vcr.html

require 'webmock/rspec'
require 'securerandom'

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

require 'naas/client'

RSpec.configure do |config|
  config.before(:all, type: :model) do
    WebMock.enable!
  end

  config.after(:all, type: :model) do
    WebMock.disable!
  end

  config.after(:each, type: :integration) do
    Naas::Requests::Accounts.destroy_data
  end

  config.after(:suite) do
    Naas::Requests::Accounts.destroy_data
  end

  config.before(:all, type: :integration) do
    WebMock.disable!

    Naas::Client.configure do |config|
      config.api_host       = ENV.fetch('NAAS_API_HOST_TEST')
      config.access_token   = ENV.fetch('NAAS_ACCESS_TOKEN_TEST')
      config.logger         = Logger.new(File.expand_path('../../log/naas_test.log', __FILE__))
      config.request_logger = Logger.new(File.expand_path('../../log/naas_test_requests.log', __FILE__))
    end
  end
end
