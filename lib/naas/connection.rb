require 'faraday_middleware'
require 'delegate'

module Naas
  class Connection < SimpleDelegator

    # Decorating the Faraday object.
    #
    # This allows for extending as necessary
    # for our needs, and allows us to be
    # flexible when utilizing an HTTP Client
    #
    # @param url [String] A tring of the URL
    #
    # @example
    #   connection = Naas::Connection.new(url: 'http://example.com') do |conn|
    #     conn.adapter(Naas::Connection.default_adapter)
    #   end
    #
    #   @connection.headers['Authorization'] = "Bearer 1234"
    #
    # @return [Naas::Connection] Faraday Connection Delegator
    def initialize(url, &block)
      @_connection = Faraday.new(url, &block)
    end

    # Return the Net::HTTP default adapter from Faraday
    #
    # @return [Symbol] Default adapter
    def self.default_adapter
      Faraday.default_adapter
    end

    # Faraday does not provide an HTTP OPTIONS call. Its
    # core library utilizes `options` for RequestOptions.
    #
    # This allows us to perform an HTTP options request
    #
    # @param url [String] The URL to make the request to
    # @param params [Hash] Request parameters to send
    # @param headers [Hash] Request headers to send
    #
    # @return [Faraday::Response] Faraday Response
    def http_options(url=nil, params=nil, headers=nil)
      @_connection.run_request(:options, url, params, headers)
    end

    # Specify the class for the Delegator
    #
    # @return [Faraday]
    def __getobj__
      @_connection
    end
  end
end
