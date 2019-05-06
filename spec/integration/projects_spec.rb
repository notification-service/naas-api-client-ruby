require 'spec_helper'
#require 'client_configuration'

RSpec.describe(Naas::Models::Projects) do
  before(:all) do
    Naas::Client.configure do |config|
      config.api_host       = ENV.fetch('NAAS_API_HOST_TEST')
      config.access_token   = ENV.fetch('NAAS_ACCESS_TOKEN_TEST')
      config.logger         = Logger.new(File.expand_path('../../../log/naas_test.log', __FILE__))
      config.request_logger = Logger.new(File.expand_path('../../../log/naas_test_requests.log', __FILE__))
    end

    WebMock.disable!
  end


  describe ".list" do
    it "returns an empty list with no projects" do
      records = described_class.list

      expect(records.any?).to be(false)
    end
  end
end
