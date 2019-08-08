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
