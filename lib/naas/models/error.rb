module Naas
  module Models
    class Error
      # Returns an instance of the Error
      #
      # @param attributes [Hash]
      #
      # @return [Naas::Models::Error]
      def initialize(attributes={})
        @attributes = attributes
      end

      # Returns the HTTP status of the error
      #
      # @return [Integer]
      def status
        @attributes['status']
      end

      # Returns the HTTP message of the error
      #
      # @return [String]
      def message
        @attributes['message']
      end

      # Returns the errors attributes collection
      #
      # @return [Array]
      def errors_attributes
        @attributes.fetch('errors', [])
      end

      # Returns the collection of ErrorItems
      #
      # @return [Naas::Models::ErrorItems]
      def errors
        Naas::Models::ErrorItems.new(self.errors_attributes)
      end

      # Returns true if there are any errors
      #
      # @return [Boolean]
      def errors?
        self.errors.any?
      end
    end
  end
end
