module Naas
  module Models
    class EmailNotificationStatus
      include Comparable

      # Returns an instance of the Email Notification Status
      #
      # @param attributes [Hash]
      #
      # @return [Naas::Models::EmailNotificationStatus]
      def initialize(attributes={})
        @attributes = attributes
      end

      # Returns the ID of the record
      #
      # @note: This is the ID of the Email Notification Status object
      #
      # @return [Integer]
      def id
        @attributes['id']
      end

      # Returns the email notification id
      #
      # @return [Integer]
      def email_notification_id
        @attributes['email_notification_id']
      end

      # Returns the status name
      #
      # @return [String]
      def status_name
        @attributes['status_name']
      end

      # Returns the started at timestamp
      #
      # @return [DateTime,NilClass]
      def started_at
        begin
          DateTime.parse(@attributes['started_at'])
        rescue
          nil
        end
      end

      # Returns the elapsed seconds
      #
      # @return [Integer]
      def elapsed_seconds
        @attributes['elapsed_seconds']
      end

      # Returns the elapsed_duration
      #
      # @return [String]
      def elapsed_duration
        @attributes['elapsed_duration']
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
