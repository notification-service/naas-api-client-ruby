module Naas
  module Models
    class EmailNotificationStatuses
      include Enumerable

      # Return an instance of the email notification statuses
      #
      # @param collection [Array]
      #
      # @return [Naas::Models::EmailNotificationStatuses]
      def initialize(collection)
        @collection = Array(collection)
      end

      # Helper method to retrieve from the request
      #
      # @param email_notification_id [Integer]
      # @param params [Hash]
      #
      # @return [Naas::Models::EmailNotificationStatus]
      def self.retrieve_by_email_notification_id(email_notification_id, params={})
        request = Naas::Requests::EmailNotificationStatuses.retrieve_by_email_notification_id(email_notification_id, params)

        request.on(:success) do |resp|
          return Naas::Models::EmailNotificationStatus.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the email notification status: %s" % [resp.status]) }
        end
      end

      def each(&block)
        internal_collection.each(&block)
      end

      private
      def internal_collection
        @collection.map { |record| Naas::Models::EmailNotificationStatus.new(record) }
      end
    end
  end
end
