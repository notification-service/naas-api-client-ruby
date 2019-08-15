module Naas
  module Models
    class SubscriberProjectProperties
      include Enumerable

      # Returns an instance of the subscriber project properties
      #
      # These are the records of full union between available
      # properties and subscriber added values.
      #
      # @param collection [Array]
      #
      # @return [Naas::Models::SubscriberProjectProperties]
      def initialize(collection)
        @collection = Array(collection)
      end

      def each(&block)
        internal_collection.each(&block)
      end

      private
      def internal_collection
        @collection.map { |record| Naas::Models::SubscriberProjectProperty.new(record) }
      end
    end
  end
end
