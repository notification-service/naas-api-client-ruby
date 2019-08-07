module Naas
  module Models
    class ProjectProperty
      include Comparable

      # Returns an instance of the Project Property
      #
      # @param attributes [Hash]
      #
      # @return [Naas::Models::ProjectProperty]
      def initialize(attributes={})
        @attributes = attributes
      end

      #
      # @return [Integer]
      def id
        @attributes['id']
      end

      # Returns the associated project id
      #
      # @return [Integer]
      def project_id
        @attributes['project_id']
      end

      # Returns the associated data type id
      #
      # @return [Integer]
      def data_type_id
        @attributes['data_type_id']
      end

      # Returns the data type attributes
      #
      # @return [Hash]
      def data_type_attributes
        @attributes.fetch('data_type', {})
      end

      # Returns true if there are data type attributes
      #
      # @return [Boolean]
      def data_type_attributes?
        !self.data_type_attributes.empty?
      end

      # Returns the data type model
      #
      # @return [Naas::Models::DataType,NilClass]
      def data_type
        if self.data_type_attributes?
          Naas::Models::DataType.new(self.data_type_attributes)
        else
          Naas::Models::DataTypes.retrieve(self.data_type_id)
        end
      end

      # Returns the name
      #
      # @return [String]
      def name
        @attributes['name']
      end

      # Returns the key name
      #
      # @return [String]
      def key_name
        @attributes['key_name']
      end

      # Returns the description
      #
      # @return [String]
      def description
        @attributes['description']
      end

      # Returns true if is subscriber editable
      #
      # @return [Boolean]
      def is_subscriber_editable
        @attributes['is_subscriber_editable']
      end
      alias is_subscriber_editable? is_subscriber_editable
      alias subscriber_editable? is_subscriber_editable

      # Returns true if is subscriber viewable
      #
      # @return [Boolean]
      def is_subscriber_viewable
        @attributes['is_subscriber_viewable']
      end
      alias is_subscriber_viewable? is_subscriber_viewable
      alias subscriber_viewable? is_subscriber_viewable

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

      # Serialized the record as an array
      #
      # @return [Array]
      def to_a
        [self.id, self.project_id, self.data_type_id, self.name, self.key_name, self.description, self.is_subscriber_editable, self.is_subscriber_viewable, self.created_at]
      end
    end
  end
end
