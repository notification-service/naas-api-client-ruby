require File.expand_path('../configurations', __FILE__)

module Naas
  class Configuration
    # Connection
    attr_accessor :api_host
    attr_accessor :access_token
    attr_accessor :connection_options

    # Request
    attr_accessor :user_agent
    attr_accessor :media_type
    attr_accessor :content_type

    # Logging
    attr_accessor :request_logger
    attr_accessor :cache_logger
    attr_accessor :logger

    # Returns the set of allows configuration
    # options
    #
    # @return [Array<Symbol>] Configuration keys
    def self.keys
      @keys ||= [
        :api_host,
        :access_token,
        :connection_options,
        :user_agent,
        :media_type,
        :content_type,
        :request_logger,
        :cache_logger,
        :logger
      ]
    end

    # Create a new instance of the Configuration object.
    #
    # This will be initialized with user-supplied values
    # or vall back to the Default configuration object
    #
    # @example
    #   configuration = Naas::Configuration.new(access_token: 'abcd')
    #
    #   configuration.access_token
    #   # => "abcd"
    #
    # @param attributes [Hash] Hash of configuration keys and values
    #
    # @return [Naas::Configuration] Instance of the object
    #
    def initialize(attributes={})
      self.class.keys.each do |key|
        instance_variable_set(:"@#{key}", (attributes[key] || Naas::Configurations::Default.options[key]))
      end
    end

    # The final set of connection options..
    #
    # @return [Hash] Connection options
    def connection_options
      {
        :headers => {
          :accept       => self.media_type,
          :user_agent   => self.user_agent,
          :content_type => self.content_type
        }
      }
    end

    # Allows you to configure the object after it's
    # been initialized.
    #
    # @return [Naas::Configuration] The configuration instance
    def configure(&block)
      yield(self)
    end

    # This allows you to reset your configuration back to the
    # default state
    #
    # @return [Naas::Configuration] The configuration with Defaults applied
    def reset!
      self.class.keys.each do |key|
        instance_variable_set(:"@#{key}", Naas::Configurations::Default.options[key])
      end
    end
    alias :setup :reset!
  end
end
