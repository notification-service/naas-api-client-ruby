module Naas
  module Models
    class Invitations
      include Enumerable

      COLUMNS = ['ID', 'Account Addon', 'Subscriber', 'Recipient', 'Created At', 'Accepted At', 'Declined At']

      # Return an instance of the invitations
      #
      # @param collection [Array]
      #
      # @return [Naas::Models::Invitations]
      def initialize(collection)
        @collection = Array(collection)
      end

      # Helper to retrieve the headings collection
      #
      # @return [Array]
      def self.headings
        COLUMNS
      end

      # Returns the class level headings
      #
      # @return [Array]
      def headings
        self.class.headings
      end

      # Helper method to retrieve from the
      # request
      #
      # @param params [Hash]
      #
      # @return [Naas::Models::Invitations]
      def self.list(params={})
        request = Naas::Requests::Invitations.list(params)

        klass_attributes = []

        request.on(:success) do |resp|
          klass_attributes = resp.data_attributes
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the invitations: %s" % [resp.status]) }
        end

        self.new(klass_attributes)
      end

      # Helper method to retrieve from the request
      #
      # @param id [String]
      # @param params [Hash]
      #
      # @return [Naas::Models::Invitation]
      def self.retrieve(id, params={})
        request = Naas::Requests::Invitations.retrieve(id, params)

        request.on(:success) do |resp|
          return Naas::Models::Invitation.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the invitation: %s" % [resp.status]) }

          return nil
        end

        nil
      end

      # Retrieve the model from the request
      #
      # @param id [String]
      # @param params [Hash]
      #
      # @raises [Naas::Errors::RecordNotFoundError]
      #
      # @return [Naas::Models::Invitation]
      def self.retrieve!(id, params={})
        request = Naas::Requests::Invitations.retrieve(id, params)

        request.on(:success) do |resp|
          return Naas::Models::Invitation.new(resp.data_attributes)
        end

        request.on(404) do
          raise Naas::Errors::RecordNotFoundError.new("Could not find record with id: %s" % [id])
        end
      end

      # Accept the invitation
      #
      # @param id [String]
      # @param params [Hash]
      #
      # @return [Naas::Models::Invitation,NilClass]
      def self.accept(id, params={})
        request = Naas::Requests::Invitations.accept(id, params)

        request.on(:success) do |resp|
          return Naas::Models::Invitation.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the invitation: %s" % [resp.status]) }

          return nil
        end

        nil
      end

      # Decline the invitation
      #
      # @param id [String]
      # @param params [Hash]
      #
      # @return [Naas::Models::Invitation,NilClass]
      def self.decline(id, params={})
        request = Naas::Requests::Invitations.decline(id, params)

        request.on(:success) do |resp|
          return Naas::Models::Invitation.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the invitation: %s" % [resp.status]) }

          return nil
        end

        nil
      end


      def each(&block)
        internal_collection.each(&block)
      end

      # Returns the collection serialized as an array
      #
      # @return [Array]
      def to_a
        self.map(&:to_a)
      end

      private
      def internal_collection
        @collection.map { |record| Naas::Models::Invitation.new(record) }
      end
    end
  end
end
