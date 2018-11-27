module Naas
  module Models
    class EmailNotificationDeliveries
      include Enumerable

      # Return an instance of the email notification deliveries
      #
      # @param collection [Array]
      #
      # @return [Naas::Models::EmailNotificationDeliveries]
      def initialize(collection)
        @collection = Array(collection)
      end

      # Helper method to retrieve from the
      # request
      #
      # @param email_notification_id [Integer]
      # @param params [Hash]
      #
      # @return [Naas::Models::EmailNotificationDeliveries]
      def self.list_by_email_notification_id(email_notification_id, params={})
        request = Naas::Requests::EmailNotificationDeliveries.list_by_email_notification_id(email_notification_id, params)

        klass_attributes = []

        request.on(:success) do |resp|
          response_body = resp.body
          response_data = response_body.fetch('data', [])

          klass_attributes = response_data
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.info { ("Failure retrieving the email notification deliveries: %s" % [resp.status]) }
        end

        self.new(klass_attributes)
      end

      # Helper method to retrieve from the request
      #
      # @param email_notification_id [Integer]
      # @param id [Integer]
      # @param params [Hash]
      #
      # @return [Naas::Models::EmailNotificationDelivery]
      def self.retrieve_by_email_notification_id(email_notification_id, id, params={})
        request = Naas::Requests::EmailNotificationDeliveries.retrieve_by_email_notification_id(email_notification_id, id, params)

        klass_attributes = {}

        request.on(:success) do |resp|
          response_body = resp.body
          response_data = response_body.fetch('data', {})

          klass_attributes = response_data
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.info { ("Failure retrieving the email notification delivery: %s" % [resp.status]) }
        end

        Naas::Models::EmailNotificationDelivery.new(klass_attributes)
      end

      def each(&block)
        internal_collection.each(&block)
      end

      private
      def internal_collection
        @collection.map { |record| Naas::Models::EmailNotificationDelivery.new(record) }
      end
    end
  end
end
