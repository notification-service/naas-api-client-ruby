module Naas
  module Models
    class ErrorItems
      include Enumerable

      # Returns an instance of the ErrorItems
      #
      # @param collection [Array]
      #
      # @return [Naas::Models::ErrorItems]
      def initialize(collection, &block)
        @collection = Array(collection)
      end

      # Implement Enumerable
      def each(&block)
        internal_collection.each(&block)
      end

      # Returns the ful messages as a string
      #
      # @return [String]
      def full_messages
        self.map(&:full_message).join(', ')
      end

      private
      def internal_collection
        @collection.map { |record| Naas::Models::ErrorItem.new(record) }
      end
    end
  end
end
