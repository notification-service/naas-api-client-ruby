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

    def redirect?
      STATUS_MAP[:redirect].include?(self.status)
    end

    def failure?
      STATUS_MAP[:failure].include?(self.status)
    end

    def server_error?
      STATUS_MAP[:server_error].include?(self.status)
    end

    def __getobj__
      @_response
    end

    def allow_header
      self.headers.fetch('allow', '')
    end

    def json?
      self.body.is_a?(Hash)
    end

    def data_attributes
      if self.json?
        self.body['data']
      end
    end

    def data_attributes?
      !self.data.nil?
    end

    def pagination_body_attributes
      if self.json?
        self.body['pagination']
      end
    end

    def pagination_body_attributes?
      !self.pagination_body_attributes.nil?
    end

    def pagination_header_attributes
      {
        'page'             => self.headers['x-pagination-page'].to_i,
        'per_page'         => self.headers['x-pagination-perpage'].to_i,
        'total'            => self.headers['x-pagination-total'].to_i,
        'maximum_per_page' => self.headers['x-pagination-maximumperpage'].to_i
      }
    end

    def pagination_header_attributes?
      self.headers.has_key?('x-pagination-page') &&
      self.headers.has_key?('x-pagination-perpage') &&
      self.headers.has_key?('x-pagination-total') &&
      self.headers.has_key?('x-pagination-maximumperpage')
    end

    def resolved_pagination_attributes
      resolved_attributes = {}

      if self.pagination_body_attributes?
        resolved_attributes = self.pagination_body_attributes
      elsif self.pagination_header_attributes?
        resolved_attributes = self.pagination_header_attributes
      else
        {}
      end
    end

    def resolved_pagination_attributes?
      !self.resolved_pagination_attributes.empty?
    end

    def pagination
      if self.resolved_pagination_attributes?
        Naas::Models::Pagination.new(self.resolved_pagination_attributes)
      end
    end

    def pagination?
      !self.pagination.nil?
    end

    def links_header
      self.headers.fetch('link', '')
    end

    def links_header?
      self.headers.has_key?('link')
    end

    def links_attributes
      if self.json?
        self.body['links']
      else
        []
      end
    end

    def links_attributes?
      self.links_attributes.any?
    end

    def links?
      self.links.any?
    end

    def allowed_methods
      self.allow_header.split(',').map(&:strip).map(&:upcase)
    end
  end
end
