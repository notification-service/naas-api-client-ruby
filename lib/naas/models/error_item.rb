module Naas
  module Models
    class ErrorItem
      include Comparable

      # Returns an instance of the ErrorItem
      #
      # @param attributes [Hash]
      #
      # @return [Naas::Models::ErrorItem]
      def initialize(attributes={})
        @attributes = attributes
      end

      # Returns the custom code of the specific error
      #
      # @return [String]
      def code
        @attributes['code']
      end

      # Returns the corresponding field, if applicable.
      # Otherwise this returns `base`
      #
      # @return [String]
      def field
        @attributes['field']
      end

      # Returns the message
      #
      # @return [String]
      def message
        @attributes['message']
      end

      # Returns the fully formatted message
      #
      # @return [String]
      def full_message
        self.message
      end
    end
  end
end
