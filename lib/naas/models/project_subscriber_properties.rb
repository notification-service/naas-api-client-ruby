module Naas
  module Models
    class ProjectSubscriberProperties
      include Enumerable

      # Returns an instance of the project subscriber properties
      #
      # @param collection [Array]
      #
      # @return [Naas::Models::ProjectSubscriberProperties]
      def initialize(collection)
        @collection = Array(collection)
      end

      def each(&block)
        internal_collection.each(&block)
      end

      private
      def internal_collection
        @collection.map { |record| Naas::Models::ProjectSubscriberProperty.new(record) }
      end
    end
  end
end
