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


      # deliver the email notification
      #
      # @note: The response from this is a redirect to then retrieve the
      # status. It is not immediately available in the response.
      #
      # @param id [Integer]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.deliver(id, params={})
        request = Naas::Requests::EmailNotifications.deliver(id, params)

        request.on(:success) do |resp|
          Naas::Client.configuration.logger.info { ("Delivered email notification: %s" % [resp.status]) }
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure delivering the email notification: %s" % [resp.status]) }
        end
      end

      # Helper method to retrieve from the
      # request
      #
      # @param params [Hash]
      #
      # @return [Naas::Models::EmailNotifications]
      def self.list(params={})
        request = Naas::Requests::EmailNotifications.list(params)

        klass_attributes = []

        request.on(:success) do |resp|
          klass_attributes = resp.data_attributes
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.info { ("Failure retrieving the email notifications: %s" % [resp.status]) }
        end

        self.new(klass_attributes)
      end

      # Helper method to retrieve from the request
      #
      # @param id [Integer]
      # @param params [Hash]
      #
      # @return [Naas::Models::EmailNotification]
      def self.retrieve(id, params={})
        request = Naas::Requests::EmailNotifications.retrieve(id, params)

        klass_attributes = {}

        request.on(:success) do |resp|
          klass_attributes = resp.data_attributes
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.info { ("Failure retrieving the email notification: %s" % [resp.status]) }
        end

        Naas::Models::EmailNotification.new(klass_attributes)
      end

      # Helper method to retrieve from the request
      #
      # @param id [Integer]
      # @param params [Hash]
      #
      # @raises [Naas::Errors::RecordNotFoundError]
      #
      # @return [Naas::Models::EmailNotification]
      def self.retrieve!(id, params={})
        request = Naas::Requests::EmailNotifications.retrieve(id, params)

        request.on(:success) do |resp|
          return Naas::Models::EmailNotification.new(resp.data_attributes)
        end

        request.on(404) do
          raise Naas::Errors::RecordNotFoundError.new("Could not find record with id: %s" % [id])
        end
      end

      # Create a new email notification
      #
      # @param params [Hash]
      #
      # @raises [Naas::InvalidRequestError]
      #
      # @return [Naas::Models::EmailNotification]
      def self.create(params={})
        request = Naas::Requests::EmailNotifications.create(params)

        request.on(:success) do |resp|
          return Naas::Models::EmailNotification.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          error           = Naas::Models::Error.new(resp.data_attributes)
          failure_message = "Failure creating the record: %s" % [error.full_messages.inspect]

          Naas::Client.configuration.logger.info { failure_message }

          raise Naas::Errors::InvalidRequestError.new(failure_message)
        end
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
