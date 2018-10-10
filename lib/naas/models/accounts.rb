module Naas
  module Models
    class Accounts
      include Enumerable

      # Return an instance of the projects
      #
      # @param collection [Array]
      #
      # @return [Naas::Models::Accounts]
      def initialize(collection)
        @collection = Array(collection)
      end

      # Helper method to retrieve from the request
      #
      # @return [Naas::Models::Account]
      def self.retrieve(params={})
        request = Naas::Requests::Accounts.retrieve(params)

        klass_attributes = {}

        request.on(:success) do |resp|
          response_body = resp.body
          response_data = response_body.fetch('data', {})

          klass_attributes = response_data
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.info { ("Failure retrieving the account: %s" % [resp.status]) }
        end

        Naas::Models::Account.new(klass_attributes)
      end

      def each(&block)
        internal_collection.each(&block)
      end

      private
      def internal_collection
        @collection.map { |record| Naas::Models::Account.new(record) }
      end
    end
  end
end
