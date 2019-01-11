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

        request.on(:success) do |resp|
          return Naas::Models::Account.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the account: %s" % [resp.status]) }

          return nil
        end
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
