module Naas
  module Models
    class SubscriberEmailAddress
      include Comparable

      # Returns an instance of the SubscriberEmailAddress
      #
      # @param attributes [Hash]
      #
      # @return [Naas::Models::SubscriberEmailAddress]
      def initialize(attributes={})
        @attributes = attributes
      end

      # Returns the ID
      #
      # @return [Integer]
      def id
        @attributes['id']
      end

      # Returns the subscriber id
      #
      # @return [Integer]
      def subscriber_id
        @attributes['subscriber_id']
      end

      # Returns the subscriber attributes
      #
      # @return [Hash]
      def subscriber_attributes
        @attributes.fetch('subscriber', {})
      end

      # Returns true if there are subscriber attributes
      #
      # @return [Boolean]
      def subscriber_attributes?
        !self.subscriber_attributes.nil? && !self.subscriber_attributes.empty?
      end

      # Returns the Subscriber domain model
      #
      # @return [Naas::Models::Subscriber]
      def subscriber
        @subscriber ||= if self.subscriber_attributes?
                          Naas::Models::Subscriber.new(self.subscriber_attributes)
                        else
                          Naas::Models::Subscribers.retrieve(self.subscriber_id)
                        end
      end

      # Returns the email address
      #
      # @return [String]
      def email_address
        @attributes['email_address']
      end

      # Returns the email address hash
      #
      # @return [String]
      def email_address_hash
        @attributes['email_address_hash']
      end
      alias :md5 :email_address_hash

      # Returns true if is the primary email
      #
      # @return [Boolean]
      def is_primary
        @attributes.fetch('is_primary', false)
      end
      alias is_primary? is_primary
      alias primary? is_primary

      # Returns the confirmation code for the
      # record
      #
      # @return [String]
      def confirmation_code
        @attributes['confirmation_code']
      end

      # Returns true if this record is confirmed
      #
      # @return [Boolean]
      def is_confirmed
        @attributes.fetch('is_confirmed', false)
      end
      alias is_confirmed? is_confirmed
      alias confirmed? is_confirmed

      # Returns the confirmed at timestamp
      #
      # @return [DateTime,NilClass]
      def confirmed_at
        begin
          DateTime.parse(@attributes['confirmed_at'])
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
    end
  end
end
