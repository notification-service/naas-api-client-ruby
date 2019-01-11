module Naas
  module Models
    class Subscribers
      include Enumerable

      # Return an instance of the subscribers
      #
      # @param collection [Array]
      #
      # @return [Naas::Models::Subscribers]
      def initialize(collection)
        @collection = Array(collection)
      end

      # Helper method to retrieve from the
      # request
      #
      # @param params [Hash]
      #
      # @return [Naas::Models::Subscribers]
      def self.list(params={})
        request = Naas::Requests::Subscribers.list(params)

        klass_attributes = []

        request.on(:success) do |resp|
          klass_attributes = resp.data_attributes
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the subscribers: %s" % [resp.status]) }
        end

        self.new(klass_attributes)
      end

      # Helper method to retrieve from the request
      #
      # @param id [Integer]
      # @param params [Hash]
      #
      # @return [Naas::Models::Subscriber]
      def self.retrieve(id, params={})
        request = Naas::Requests::Subscribers.retrieve(id, params)

        request.on(:success) do |resp|
          return Naas::Models::Subscriber.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the subscriber: %s" % [resp.status]) }

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
      # @return [Naas::Models::Subscriber]
      def self.retrieve!(id, params={})
        request = Naas::Requests::Subscribers.retrieve(id, params)

        request.on(:success) do |resp|
          return Naas::Models::Subscriber.new(resp.data_attributes)
        end

        request.on(404) do
          raise Naas::Errors::RecordNotFoundError.new("Could not find record with id: %s" % [id])
        end
      end

      # Create a new subscriber
      #
      # @param params [Hash]
      #
      # @raises [Naas::InvalidRequestError]
      #
      # @return [Naas::Models::Subscriber]
      def self.create(params={})
        request = Naas::Requests::Subscribers.create(params)

        request.on(:success) do |resp|
          return Naas::Models::Subscriber.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          error           = Naas::Models::Error.new(resp.data_attributes)
          failure_message = "Failure creating the record: %s" % [error.full_messages.inspect]

          Naas::Client.configuration.logger.error { failure_message }

          raise Naas::Errors::InvalidRequestError.new(failure_message)
        end
      end

      def each(&block)
        internal_collection.each(&block)
      end

      private
      def internal_collection
        @collection.map { |record| Naas::Models::Subscriber.new(record) }
      end
    end
  end
end
