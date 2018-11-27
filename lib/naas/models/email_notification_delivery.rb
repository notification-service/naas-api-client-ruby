module Naas
  module Models
    class EmailNotificationDelivery
      include Comparable

      # Returns an instance of the Email Notification Delivery
      #
      # @param attributes [Hash]
      #
      # @return [Naas::Models::EmailNotificationDelivery]
      def initialize(attributes={})
        @attributes = attributes
      end

      # Returns the ID
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

      # Returns the owner name
      #
      # @return [String]
      def owner_name
        @attributes['owner_name']
      end

      # Returns true if this was started
      #
      # @return [Boolean]
      def is_started
        @attributes.fetch('is_started', false)
      end
      alias :started? :is_started

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

      # Returns true if this was completed
      #
      # @return [Boolean]
      def is_completed
        @attributes.fetch('is_completed', false)
      end
      alias :completed? :is_completed

      # Returns the completed at timestamp
      #
      # @return [DateTime,NilClass]
      def completed_at
        begin
          DateTime.parse(@attributes['completed_at'])
        rescue
          nil
        end
      end

      # Returns true if this was canceled
      #
      # @return [Boolean]
      def is_canceled
        @attributes.fetch('is_canceled', false)
      end
      alias :canceled? :is_canceled

      # Returns the canceled at timestamp
      #
      # @return [DateTime,NilClass]
      def canceled_at
        begin
          DateTime.parse(@attributes['canceled_at'])
        rescue
          nil
        end
      end

      # Returns true if this was errored
      #
      # @return [Boolean]
      def is_errored
        @attributes.fetch('is_errored', false)
      end
      alias :errored? :is_errored

      # Returns the errored at timestamp
      #
      # @return [DateTime,NilClass]
      def errored_at
        begin
          DateTime.parse(@attributes['errored_at'])
        rescue
          nil
        end
      end

      # Returns the duration of processing time
      #
      # @return [Integer] Seconds
      def duration
        if self.started_at && self.completed_at
          (self.completed_at.to_time.to_i - self.started_at.to_time.to_i)
        else
          0
        end
      end

      # Returns the duration as a display string
      #
      # @return [String]
      def duration_display
        Time.at(self.duration).utc.strftime("%H:%M:%S")
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
