require 'dotenv'
Dotenv.load

require 'logger'
require 'date'
require 'multi_json'
require 'restless_router'
require 'naas/client/version'

require 'naas/errors'
require 'naas/logger'
require 'naas/configuration'
require 'naas/connection'
require 'naas/response'

require 'naas/utilities'

require "naas/requests"
require "naas/models"

module Naas
  module Client
    # Class accessor methods to be utilized
    # throughout the gem itself.
    class << self
      attr_accessor :configuration
      attr_accessor :routes
    end

    # Create a default Configuration to use
    # throughout the gem
    #
    # @return [Naas::Configuration] Configuration object utilizing the Default
    def self.configuration
      @configuration ||= Naas::Configuration.new
    end

    # Specify configuration options. This will be applied to
    # our memoized Configuration.
    #
    # @return [Naas::Configuration]
    def self.configure
      yield(self.configuration)
    end

    # Helper method to access the Connection object
    #
    # @return [Naas::Connection] Faraday Response Delegator
    def self.connection
      @connection ||= Naas::Connection.new(url: self.configuration.api_host) do |builder|
        builder.response(:json, content_type: /\bjson$/)

        builder.response(:logger, self.configuration.request_logger)

        builder.adapter(Naas::Connection.default_adapter)
      end

      # Inject Authorization
      @connection.headers['Authorization'] = ("Bearer %s" % [self.configuration.access_token])

      # Merge default headers
      @connection.headers.merge!(self.configuration.connection_options[:headers])

      @connection
    end

    # Helper method to peform a GET request
    #
    # @return [Naas::Response] Faraday Response Delegator
    def self.get(url, data={}, headers={})
      request = self.connection.get(url, data, headers)

      Naas::Response.new(request)
    end

    # Helper method to perform a HEAD request
    #
    # @return [Naas::Response] Faraday Response Delegator
    def self.head(url, data={}, headers={})
      request = self.connection.head(url, data, headers)

      Naas::Response.new(request)
    end

    # Helper method to perform a OPTIONS request
    #
    # @return [Naas::Response] Faraday Response Delegator
    def self.options(url, headers={})
      request = self.connection.http_options(url, nil, headers)

      Naas::Response.new(request)
    end

    # Helper method to perform a PUT request
    #
    # @return [Naas::Response] Faraday Response Delegator
    def self.put(url, data={}, headers={})
      request = self.connection.put(url, data, headers)

      Naas::Response.new(request)
    end

    # Helper method to perform a POST request
    #
    # @return [Naas::Response] Faraday Response Delegator
    def self.post(url, data={}, headers={})
      request = self.connection.post(url, data, headers)

      Naas::Response.new(request)
    end

    def self.delete(url, data={}, headers={})
      request = self.connection.delete(url, data, headers)

      Naas::Response.new(request)
    end

    # Returns the root directory response
    #
    # @return [Naas::Models::Directory]
    def self.directory
      @directory ||= Naas::Models::Directory.retrieve
    end

    # Define the API routes
    #
    # These are the endpoints that will be used to interact
    # with the API. Before you make any requests you will
    # want to add the corresponding routes here.
    #
    # @return [RestlessRouter::Routes] A collection of Routes
    def self.routes
      return @routes if @routes

      @routes = self.directory.links

      @routes
    end

    # Returns the link relationship for
    # a specified path.
    #
    # Custom link relationships are fully qualified
    # URIS, but in this case we only care to reference
    # the path and add the API host.
    #
    # @return [String]
    def self.rel_for(rel)
      "%s/%s" % [self.api_host, rel]
    end

    # Helper method to return the API HOST
    #
    # @return [String] API URI
    def self.api_host
      self.configuration.api_host
    end
  end
end

