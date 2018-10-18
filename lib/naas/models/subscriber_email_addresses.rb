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

      # Helper method to retrieve from the
      # request
      #
      # @return [Naas::Models::SubscriberEmailAddresses]
      def self.list(params={})
        request = Naas::Requests::SubscriberEmailAddresses.list(params)

        klass_attributes = []

        request.on(:success) do |resp|
          response_body = resp.body
          response_data = response_body.fetch('data', [])

          klass_attributes = response_data
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.info { ("Failure retrieving the subscriber email addresses: %s" % [resp.status]) }
        end

        self.new(klass_attributes)
      end

      # Helper method to create from the
      # request
      #
      # @note: Will delegate to the internal model `errors`
      #
      # @return [Naas::Models::SubscriberEmailAddresses]
      def self.create(params={})
        request = Naas::Requests::SubscriberEmailAddresses.create(params)

        klass_attributes = {}

        request.on(:success) do |resp|
          response_body = resp.body
          response_data = response_body.fetch('data', [])

          klass_attributes = response_data
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.info { ("Failure retrieving the subscriber email addresses: %s" % [resp.status]) }
        end

        Naas::Models::SubscriberEmailAddress.new(klass_attributes)
      end

      # Helper method to retrieve from the request
      #
      # @return [Naas::Models::SubscriberEmailAddress]
      def self.retrieve(id, params={})
        request = Naas::Requests::SubscriberEmailAddresses.retrieve(id, params)

        klass_attributes = {}

        request.on(:success) do |resp|
          response_body = resp.body
          response_data = response_body.fetch('data', {})

          klass_attributes = response_data
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.info { ("Failure retrieving the subscriber email address: %s" % [resp.status]) }
        end

        Naas::Models::SubscriberEmailAddress.new(klass_attributes)
      end

      def each(&block)
        internal_collection.each(&block)
      end

      private
      def internal_collection
        @collection.map { |record| Naas::Models::SubscriberEmailAddress.new(record) }
      end
    end
  end
end
