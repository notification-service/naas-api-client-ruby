module Naas
  module Models
    class DataType
      include Comparable

      # Returns an instance of the DataType
      #
      # @param attributes [Hash]
      #
      # @return [Naas::Models::DataType]
      def initialize(attributes={})
        @attributes = attributes
      end

      # Returns the ID
      #
      # @return [Integer]
      def id
        @attributes['id']
      end

      # Returns the name
      #
      # @return [String]
      def name
        @attributes['name']
      end

      # Returns the description
      #
      # @return [String]
      def description
        @attributes['description']
      end

      # Returns the created at timestamp
      #
      # @return [DateTime,NilClass]
      def created_at
        begin
          DateTime.parse(@attributes['created_at'])
        rescue
          nil
        end
      end

      # Returns the updated at timestamp
      #
      # @return [DateTime,NilClass]
      def updated_at
        begin
          DateTime.parse(@attributes['updated_at'])
        rescue
          nil
        end
      end

      # Returns the links attributes
      #
      # @return [Array]
      def links_attributes
        @attributes.fetch('links', [])
      end

      # Returns the Links
      #
      # @return [Naas::Models::Links]
      def links
        @links ||= Naas::Models::Links.new(self.links_attributes)
      end

      # Returns true if there are any links
      #
      # @return [Boolean]
      def links?
        self.links.any?
      end

      # Returns the record serialized as an array
      #
      # @return [Array]
      def to_a
        [self.id, self.name, self.description, self.created_at]
      end

      # Returns the record as an option
      #
      # @return [Array]
      def to_option
        [self.name, self.id]
      end
    end
  end
end
