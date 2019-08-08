module Naas
  module Models
    class SubscriberEmailAddresses
      include Enumerable

      # Return an instance of the subscriber email addresses
      #
      # @param collection [Array]
      #
      # @return [Naas::Models::SubscriberEmailAddresses]
      def initialize(collection)
        @collection = Array(collection)
      end

      # Helper method to retrieve from the request
      #
      # @param subscriber_id [Integer]
      # @param params [Hash]
      #
      # @return [Naas::Models::SubscriberEmailAddreses]
      def self.list_by_subscriber_id(subscriber_id, params={})
        request = Naas::Requests::SubscriberEmailAddresses.list_by_subscriber_id(subscriber_id, params)

        klass_attributes = []

        request.on(:success) do |resp|
          klass_attributes = resp.data_attributes
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the subscriber email addresses: %s" % [resp.status]) }
        end

        self.new(klass_attributes)
      end

      # Helper method to retrieve from the
      # request
      #
      # @param params [Hash]
      #
      # @return [Naas::Models::SubscriberEmailAddresses]
      def self.list(params={})
        request = Naas::Requests::SubscriberEmailAddresses.list(params)

        klass_attributes = []

        request.on(:success) do |resp|
          klass_attributes = resp.data_attributes
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the subscriber email addresses: %s" % [resp.status]) }
        end

        self.new(klass_attributes)
      end

      # Create a new subscriber email address
      #
      # @param params [Hash]
      #
      # @raises [Naas::InvalidRequestError]
      #
      # @return [Naas::Models::SubscriberEmailAddress]
      def self.create(params={})
        request = Naas::Requests::SubscriberEmailAddresses.create(params)

        request.on(:success) do |resp|
          return Naas::Models::SubscriberEmailAddress.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          error           = Naas::Models::Error.new(resp.data_attributes)
          failure_message = "Failure creating the record: %s" % [error.full_messages.inspect]

          Naas::Client.configuration.logger.error { failure_message }

          raise Naas::Errors::InvalidRequestError.new(failure_message)
        end
      end

      # Helper method to retrieve from the request
      #
      # @param id [Integer]
      # @param params [Hash]
      #
      # @return [Naas::Models::SubscriberEmailAddress]
      def self.retrieve(id, params={})
        request = Naas::Requests::SubscriberEmailAddresses.retrieve(id, params)

        request.on(:success) do |resp|
          return Naas::Models::SubscriberEmailAddress.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the subscriber email address: %s" % [resp.status]) }

          return nil
        end
      end

      # Helper method to retrieve from the request
      #
      # @param id [Integer]
      # @param params [Hash]
      #
      # @raises [Naas::Errors::RecordNotFoundError]
      #
      # @return [Naas::Models::SubscriberEmailAddress]
      def self.retrieve!(id, params={})
        request = Naas::Requests::SubscriberEmailAddresses.retrieve(id, params)

        request.on(:success) do |resp|
          return Naas::Models::SubscriberEmailAddress.new(resp.data_attributes)
        end

        request.on(404) do
          raise Naas::Errors::RecordNotFoundError.new("Could not find record with id: %s" % [id])
        end
      end

      def each(&block)
        internal_collection.each(&block)
      end

      # Returns the display name of a list of
      # email addresses
      #
      # @return [String]
      def display_name
        self.map(&:email_address).join(', ')
      end

      private
      def internal_collection
        @collection.map { |record| Naas::Models::SubscriberEmailAddress.new(record) }
      end
    end
  end
end
