module Naas
  module Models
    class ProjectSubscriber
      include Comparable

      # Returns an instance of the Project Subscriber
      #
      # @param attributes [Hash]
      #
      # @return [Naas::Models::ProjectSubscriber]
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

      # Returns the associated subscriber id
      #
      # @return [Integer]
      def subscriber_id
        @attributes['subscriber_id']
      end

      # Returns the eager loaded subscriber
      # attributes
      #
      # @return [Hash]
      def subscriber_attributes
        @attributes.fetch('subscriber', {})
      end

      # Returns true if there are subscriber
      # attributes
      #
      # @return [Boolean]
      def subscriber_attributes?
        !self.subscriber_attributes.empty?
      end

      # Returns the associated subscriber
      #
      # @return [Naas::Models::Subscriber]
      def subscriber
        return @subscriber if @subscriber

        @subscriber = if self.subscriber_attributes?
                        Naas::Models::Subscriber.new(self.subscriber_attributes)
                      else
                        Naas::Models::Subscribers.retrieve(self.subscriber_id)
                      end
        @subscriber
      end

      # Returns the project subscriber code
      #
      # @return [String]
      def code
        @attributes['code']
      end

      # Returns the subscriber email addresses attributes
      #
      # @return [Array]
      def subscriber_email_addresses_attributes
        @attributes.fetch('subscriber_email_addresses', [])
      end

      # Returns the collection of subscriber email addresses
      #
      # @return [Naas::Models::SubscriberEmailAddresses]
      def subscriber_email_addresses
        @subscriber_email_addresses ||= Naas::Models::SubscriberEmailAddresses.new(self.subscriber_email_addresses_attributes)
      end

      # Returns true if there are any subscriber email addresses
      #
      # @return [Boolean]
      def subscriber_email_addresses?
        self.subscriber_email_addresses.any?
      end

      # Proxy to show the list of subscriber email addresses
      #
      # @return [String]
      def subscriber_email_addresses_display_name
        self.subscriber_email_addresses.display_name
      end

      # Returns the project subscriber properties attributes
      #
      # @return [Array]
      def project_subscriber_properties_attributes
        @attributes.fetch('project_subscriber_properties', [])
      end

      # Returns true if there are any project subscriber properties
      #
      # @return [Boolean]
      def project_subscriber_properties_attributes?
        @attributes.has_key?('project_subscriber_properties')
      end

      # Returns the associated project subscriber properties
      #
      # @return [Naas::Models::ProjectSubscriberProperties]
      def project_subscriber_properties
        return @project_subscriber_properties if @project_subscriber_properties

        @project_subscriber_properties = if self.project_subscriber_properties_attributes?
                                           Naas::Models::ProjectSubscriberProperties.new(self.project_subscriber_properties_attributes)
                                         else
                                           Naas::Models::ProjectSubscriberProperties.list_by_project_id_and_project_subscriber_id(self.project_id, self.id)
                                         end

        @project_subscriber_properties
      end

      # Returns the set of available project properties
      #
      # @todo: This is similar to a has_many: through (project)
      #
      # @return [Naas::Models::ProjectProperties]
      def project_properties
        @project_properties ||= Naas::Models::ProjectProperties.list_by_project_id(self.project_id)
      end

      # This returns a collection of all project properties
      # merged with the values set by this subscriber
      #
      # @note: This is a WIP to test out this model
      #
      # @return [Array<OpenStruct>]
      def subscriber_project_properties
        return @subscriber_project_properties if @subscriber_project_properties

        records = []

        self.project_properties.inject(records) do |collection,project_property|
          record_attributes = {
            :project_property_id            => project_property.id,
            :project_subscriber_property_id => nil,
            :name                           => project_property.name,
            :key_name                       => project_property.key_name,
            :description                    => project_property.description,
            :value                          => nil,
            :is_subscriber_editable         => project_property.is_subscriber_editable,
            :is_subscriber_viewable         => project_property.is_subscriber_viewable
          }

          subscriber_value = self.project_subscriber_properties.find { |r| r.project_property_id == project_property.id }

          if !subscriber_value.nil?
            subscriber_attributes = {
              :project_subscriber_property_id => subscriber_value.id,
              :value                          => subscriber_value.value,
              :is_subscriber_editable         => subscriber_value.is_subscriber_editable
            }
            record_attributes.merge!(subscriber_attributes)
          end

          collection.push(record_attributes)
          collection
        end

        @subscriber_project_properties = Naas::Models::SubscriberProjectProperties.new(records)
      end

      # Returns true if there are any project subscriber properties
      #
      # @return [Boolean]
      def project_subscriber_properties?
        self.project_subscriber_properties.any?
      end

      # Returns the profile attributes
      #
      # @return [Hash]
      def profile_attributes
        @attributes.fetch('profile', {})
      end

      # Returns true if there are profile attributes
      #
      # @return [Boolean]
      def profile_attributes?
        !self.profile_attributes.empty?
      end

      # Returns an instance of the profile
      #
      # @return [Naas::Models::ProjectSubscriberProfile]
      def profile
        return @profile if @profile

        @profile = if self.profile_attributes?
                     Naas::Models::ProjectSubscriberProfile.new(self.profile_attributes)
                   else
                     Naas::Models::ProjectSubscriberProfile.retrieve_by_project_id_and_project_subscriber_id(self.project_id, self.id)
                   end

        @profile
      end

      # Returns true if opted in to the project
      #
      # @return [Boolean]
      def is_opted_in
        @attributes['is_opted_in']
      end
      alias is_opted_in? is_opted_in
      alias opted_in? is_opted_in

      # Returns the date they opted in to the
      # project
      #
      # @return [DateTime,NilClass]
      def opted_in_at
        begin
          DateTime.parse(@attributes['opted_in_at'])
        rescue
          nil
        end
      end

      # Returns the date they opted out of the
      # project
      #
      # @return [DateTime,NilClass]
      def opted_out_at
        begin
          DateTime.parse(@attributes['opted_out_at'])
        rescue
          nil
        end
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

      # Serialized the record as an array
      #
      # @return [Array]
      def to_a
        [self.id, self.project_id, self.subscriber_id, self.subscriber_email_addresses_display_name, self.code, self.created_at]
      end
    end
  end
end
