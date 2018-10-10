module Naas
  module Models
    class EmailNotifications
      include Enumerable

      # Return an instance of the email notifications
      #
      # @param collection [Array]
      #
      # @return [Naas::Models::EmailNotifications]
      def initialize(collection)
        @collection = Array(collection)
      end

      # Helper method to retrieve from the
      # request
      #
      # @return [Naas::Models::EmailNotifications]
      def self.list(params={})
        request = Naas::Requests::EmailNotifications.list(params)

        klass_attributes = []

        request.on(:success) do |resp|
          response_body = resp.body
          response_data = response_body.fetch('data', [])

          klass_attributes = response_data
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.info { ("Failure retrieving the email notifications: %s" % [resp.status]) }
        end

        self.new(klass_attributes)
      end

      # Helper method to retrieve from the request
      #
      # @return [Naas::Models::EmailNotification]
      def self.retrieve(id, params={})
        request = Naas::Requests::EmailNotifications.retrieve(id, params)

        klass_attributes = {}

        request.on(:success) do |resp|
          response_body = resp.body
          response_data = response_body.fetch('data', {})

          klass_attributes = response_data
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.info { ("Failure retrieving the email notification: %s" % [resp.status]) }
        end

        Naas::Models::EmailNotification.new(klass_attributes)
      end

      def each(&block)
        internal_collection.each(&block)
      end

      private
      def internal_collection
        @collection.map { |record| Naas::Models::EmailNotification.new(record) }
      end
    end
  end
end
