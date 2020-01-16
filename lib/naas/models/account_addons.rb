module Naas
  module Models
    class AccountAddons
      include Enumerable

      # Return an instance of the addons
      #
      # @param collection [Array]
      #
      # @return [Naas::Models::AccountAddons]
      def initialize(collection)
        @collection = Array(collection)
      end

      # Helper method to retrieve from the
      # request
      #
      # @param params [Hash]
      #
      # @return [Naas::Models::AccountAddons]
      def self.list(params={})
        request = Naas::Requests::AccountAddons.list(params)

        klass_attributes = []

        request.on(:success) do |resp|
          klass_attributes = resp.data_attributes
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the account addons: %s" % [resp.status]) }
        end

        self.new(klass_attributes)
      end

      # Helper method to retrieve from the request
      #
      # @param id [String]
      # @param params [Hash]
      #
      # @return [Naas::Models::AccountAddon]
      def self.retrieve(id, params={})
        request = Naas::Requests::AccountAddons.retrieve(id, params)

        request.on(:success) do |resp|
          return Naas::Models::AccountAddon.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the account addon: %s" % [resp.status]) }

          return nil
        end
      end

      # Helper method to retrieve from the request
      #
      # @param id [String]
      # @param params [Hash]
      #
      # @raises [Naas::Errors::RecordNotFoundError]
      #
      # @return [Naas::Models::AccountAddon]
      def self.retrieve!(id, params={})
        request = Naas::Requests::AccountAddons.retrieve(id, params)

        request.on(:success) do |resp|
          return Naas::Models::AccountAddon.new(resp.data_attributes)
        end

        request.on(404) do
          raise Naas::Errors::RecordNotFoundError.new("Could not find record with id: %s" % [id])
        end
      end

      # Helper method to update from the request
      #
      # @param id [String]
      # @param params [Hash]
      #
      # @raises [Naas::InvalidRequestError]
      #
      # @return [Naas::Models::AccountAddon]
      def self.update(id, params={})
        request = Naas::Requests::AccountAddons.update(id, params)

        request.on(:success) do |resp|
          return Naas::Models::AccountAddon.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          error           = Naas::Models::Error.new(resp.data_attributes)
          failure_message = "Failure updating the record: %s" % [error.full_messages.inspect]

          Naas::Client.configuration.logger.error { failure_message }

          raise Naas::Errors::InvalidRequestError.new(failure_message)
        end
      end

      def each(&block)
        internal_collection.each(&block)
      end

      private
      def internal_collection
        @collection.map { |record| Naas::Models::AccountAddon.new(record) }
      end
    end
  end
end
