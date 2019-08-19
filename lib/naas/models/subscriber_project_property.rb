module Naas
  module Models
    class SubscriberProjectProperty
      # Returns an instance of the subscriber project property
      #
      # @param attributes [Hash]
      #
      # @return [Naas::Models::SubscriberProjectProperty]
      def initialize(attributes={})
        @attributes = attributes
      end

      def project_property_id
        @attributes[:project_property_id]
      end

      def project_subscriber_property_id
        @attributes[:project_subscriber_property_id]
      end

      def project_subscriber_property_id?
        !self.project_subscriber_property_id.nil?
      end

      def subscriber_provided_value?
        self.project_subscriber_property_id?
      end

      def name
        @attributes[:name]
      end

      def key_name
        @attributes[:key_name]
      end

      def description
        @attributes[:description]
      end

      def value
        @attributes[:value]
      end

      def is_subscriber_editable
        @attributes[:is_subscriber_editable]
      end
      alias is_subscriber_editable? is_subscriber_editable
      alias subscriber_editable? is_subscriber_editable

      def is_subscriber_viewable
        @attributes[:is_subscriber_viewable]
      end
      alias is_subscriber_viewable? is_subscriber_viewable
      alias subscriber_viewable? is_subscriber_viewable
    end
  end
end
