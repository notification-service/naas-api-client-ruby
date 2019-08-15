module Naas
  module Models
    class ProjectSubscriberProperty
      include Comparable

      # Returns an instance of the project subscriber property
      #
      # @param attributes [Hash]
      #
      # @return [Naas::Models::ProjectSubscriberProperty]
      def initialize(attributes={})
        @attributes = attributes
      end

      # Returns the id
      #
      # @return [String]
      def id
        @attributes['id']
      end

      # Returns the project id
      #
      # @return [String]
      def project_id
        @attributes['project_id']
      end

      # Returns the project attributes
      #
      # @return [Hash]
      def project_attributes
        @attributes.fetch('project', {})
      end

      # Returns true if there are project attributes
      #
      # @return [Boolean]
      def project_attributes?
        !self.project_attributes.empty?
      end

      # Returns an instance of the project
      #
      # @return [Naas::Models::Project]
      def project
        return @project if @project

        @project = if self.project_attributes?
                     Naas::Models::Project.new(self.project_properties)
                   else
                     Naas::Models::Projects.retrieve(self.project_id)
                   end

        @project
      end

      # Returns the project property id
      #
      # @return [String]
      def project_property_id
        @attributes['project_property_id']
      end

      # Reeturns the project property attributes
      #
      # @return [Hash]
      def project_property_attributes
        @attributes.fetch('project_property', {})
      end

      # Returns true if there are project property attributes
      #
      # @return [Boolean]
      def project_property_attributes?
        !self.project_property_attributes.empty?
      end

      # Returns an instance of the project property
      #
      # @return [Naas::Models::ProjectProperty]
      def project_property
        return @project_property if @project_property

        @project_property = if self.project_property_attributes?
                              Naas::Models::ProjectProperty.new(self.project_property_attributes)
                            else
                              Naas::Models::ProjectProperties.retrieve_by_project_id(self.project_id, self.project_property_id)
                            end

        @project_property
      end

      # Returns the project subscriber id
      #
      # @return [String]
      def project_subscriber_id
        @attributes['project_subscriber_id']
      end

      # Returns the project subscriber attributes
      #
      # @return [Hash]
      def project_subscriber_attributes
        @attributes.fetch('project_subscriber', {})
      end

      # Returns true if there are project subscriber attributes
      #
      # @return [Boolean]
      def project_subscriber_attributes?
        !self.project_subscriber_attributes.empty?
      end

      # Returns an instance of the project subscriber
      #
      # @return [Naas::Models::ProjectSubscriber]
      def project_subscriber
        return @project_subscriber if @project_subscriber

        @project_subscriber = if self.project_subscriber_attributes?
                                Naas::Models::ProjectSubscriber.new(self.project_subscriber_attributes)
                              else
                                Naas::Models::ProjectSubscribers.retrieve_by_project_id(self.project_id, self.project_subscriber_id)
                              end

        @project_subscriber
      end

      # This is the raw value before typecase
      #
      # @return [String]
      def value_before_typecast
        @attributes['value']
      end

      def is_subscriber_editable
        @attributes['is_subscriber_editable']
      end
      alias is_subscriber_editable? is_subscriber_editable
      alias subscriber_editable? is_subscriber_editable

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
    end
  end
end
