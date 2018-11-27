module Naas
  module Models
    class EmailNotification
      include Comparable

      # Returns an instance of the Email Notification
      #
      # @param attributes [Hash]
      #
      # @return [Naas::Models::EmailNotification]
      def initialize(attributes={})
        @attributes = attributes
      end

      # Deliver for this instance
      #
      # @return [Naas::Response]
      def deliver
        Naas::Requests::EmailNotifications.deliver(self.id)
      end

      # Returns the delivery status. This is only
      # present while the notification is being delivered. It
      # will be a _redirect_ once it has completed.
      #
      # @return [Naas::Models::EmailNotificationStatus,NilClass]
      def delivery_status
        status = Naas::Requests::EmailNotificationStatuses.retrieve_by_email_notification_id(self.id)

        if status.success?
          Naas::Models::EmailNotificationStatuses.retrieve_by_email_notification_id(self.id)
        end
      end

      # Returns true if there is a current delivery status
      #
      # @return [Boolean]
      def delivery_status?
        !self.delivery_status.nil?
      end

      # Returns the Email Notification Deliveries
      #
      # @note: This will consume eager loaded attributes or
      # issue a subsequent request.
      #
      # @note: This does not auto paginate. We would need to
      # handle this from the API.
      #
      # @return [Naas::Models::EmailNotificationDeliveries]
      def email_notification_deliveries(params={})
        if self.email_notification_deliveries_attributes?
          Naas::Models::EmailNotificationDeliveries.new(self.email_notification_deliveries_attributes)
        else
          Naas::Models::EmailNotificationDeliveries.list_by_email_notification_id(self.id, params)
        end
      end

      # Returns true if there are any notification deliveries
      #
      # @return [Boolean]
      def email_notification_deliveries?
        self.email_notification_deliveries.any?
      end

      # Returns the count of the email notification deliveries
      #
      # @note: This could also consume a counter cache.
      #
      # @return [Integer]
      def email_notification_deliveries_count
        self.email_notification_deliveries.count
      end

      # Returns the email notification deliveries attributes
      # if it has been eager loaded
      #
      # @return [Array]
      def email_notification_deliveries_attributes
        @attributes.fetch('email_notification_deliveries', [])
      end

      # Returns true if there are any email notification
      # deliveries attributes
      #
      # @return [Boolean]
      def email_notification_deliveries_attributes?
        self.email_notification_deliveries_attributes.any?
      end

      # Returns the ID
      #
      # @return [Integer]
      def id
        @attributes['id']
      end

      # Returns the account smtp setting id
      #
      # @return [Integer]
      def account_smtp_setting_id
        @attributes['account_smtp_setting_id']
      end

      # Returns the campaign email template id
      #
      # @return [Integer]
      def campaign_email_template_id
        @attributes['campaign_email_template_id']
      end

      # Returns the subscriber email address id
      #
      # @return [Integer]
      def subscriber_email_address_id
        @attributes['subscriber_email_address_id']
      end

      # Returns the content
      #
      # @return [MultiJson]
      def content
        @attributes['content']
      end

      # Returns the subject
      #
      # @return [String]
      def subject
        @attributes['subject']
      end

      # Returns the from email address
      #
      # @return [String]
      def from_email_address
        @attributes['from_email_address']
      end

      # Returns the from name
      #
      # @return [String]
      def from_name
        @attributes['from_name']
      end

      # Returns the to email address
      #
      # @return [String]
      def to_email_address
        @attributes['to_email_address']
      end

      # Returns the email to name
      #
      # @return [String]
      def to_name
        @attributes['to_name']
      end

      # Returns the html body
      #
      # @return [String]
      def html_body
        @attributes['html_body']
      end

      # Returns the text body
      #
      # @return [String]
      def text_body
        @attributes['text_body']
      end

      # Returns the sent count
      #
      # @return [Integer]
      def sent_count
        @attributes.fetch('sent_count', 0)
      end

      # Returns true if sent
      #
      # @return [Boolean]
      def is_sent
        @attributes['is_sent'] || false
      end
      alias :sent? :is_sent

      # Returns true if processing
      #
      # @return [Boolean]
      def is_processing
        @attributes['is_processing'] || false
      end
      alias :processing? :is_processing

      # Returns true if this is deliverable
      #
      # @return [Boolean]
      def is_deliverable
        @attributes.fetch('is_deliverable', false)
      end
      alias :deliverable? :is_deliverable

      # Returns the checksum of the content
      #
      # @return [String]
      def checksum
        @attributes['checksum']
      end
      alias :fingerprint :checksum

      # Returns the last sent at timestamp
      #
      # @return [DateTime,NilClass]
      def last_sent_at
        begin
          DateTime.parse(@attributes['last_sent_at'])
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
