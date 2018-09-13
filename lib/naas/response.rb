require File.expand_path('../utilities/status_code_mapper', __FILE__)
require 'faraday_middleware'
require 'delegate'

module Naas
  class Response < SimpleDelegator
    STATUS_MAP = {
      :failure      => (400...500),
      :redirect     => (300...400),
      :success      => (200...300),
      :server_error => (500...600)
    }

    def initialize(response)
      @_response = response
    end

    def allowed?(method)
      self.allowed_methods.include?(method.upcase)
    end

    def on(*statuses, &block)
      status_code_mapper = Naas::Utilities::StatusCodeMapper.new(statuses)

      return unless status_code_mapper.includes?(@_response.status)

      if block_given?
        yield(self)
      else
        self
      end
    end

    def __getobj__
      @_response
    end

    def allow_header
      self.headers.fetch('allow', '')
    end

    def allowed_methods
      self.allow_header.split(',').map(&:strip).map(&:upcase)
    end
  end
end
