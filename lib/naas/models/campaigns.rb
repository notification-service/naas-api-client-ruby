module Naas
  module Models
    class Campaigns
      include Enumerable

      # Return an instance of the campaigns
      #
      # @param collection [Array]
      #
      # @return [Naas::Models::Campaigns]
      def initialize(collection)
        @collection = Array(collection)
      end


      # Helper method to retrieve from the
      # request
      #
      # @param project_id [String]
      # @param params [Hash]
      #
      # @return [Naas::Models::Campaigns]
      def self.list_by_project_id(project_id, params={})
        request = Naas::Requests::Campaigns.list_by_project_id(project_id, params)

        klass_attributes = []

        request.on(:success) do |resp|
          klass_attributes = resp.data_attributes
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.info { ("Failure retrieving the campaigns: %s" % [resp.status]) }
        end

        self.new(klass_attributes)
      end

      # Helper method to retrieve from the request
      #
      # @param project_id [String]
      # @param id [String]
      # @param params [Hash]
      #
      # @return [Naas::Models::Campaign]
      def self.retrieve_by_project_id(project_id, id, params={})
        request = Naas::Requests::Campaigns.retrieve_by_project_id(project_id, id, params)

        klass_attributes = {}

        request.on(:success) do |resp|
          klass_attributes = resp.data_attributes
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.info { ("Failure retrieving the campaign: %s" % [resp.status]) }
        end

        Naas::Models::Campaign.new(klass_attributes)
      end

      # Helper method to retrieve from the request
      #
      # @param project_id [String]
      # @param id [String]
      # @param params [Hash]
      #
      # @raises [Naas::Errors::RecordNotFoundError]
      #
      # @return [Naas::Models::Campaign]
      def self.retrieve_by_project_id!(project_id, id, params={})
        request = Naas::Requests::Campaigns.retrieve_by_project_id(project_id, id, params)

        request.on(:success) do |resp|
          return Naas::Models::Campaign.new(resp.data_attributes)
        end

        request.on(404) do
          raise Naas::Errors::RecordNotFoundError.new("Could not find record with id: %s" % [id])
        end
      end

      # Create a new campaign
      #
      # @param project_id [String]
      # @param params [Hash]
      #
      # @raises [Naas::InvalidRequestError]
      #
      # @return [Naas::Models::Campaign]
      def self.create_by_project_id(project_id, params={})
        request = Naas::Requests::Campaigns.create_by_project_id(project_id, params)

        request.on(:success) do |resp|
          klass_attributes = resp.data_attributes

          return Naas::Models::Campaign.new(klass_attributes)
        end

        request.on(:failure) do |resp|
          error           = Naas::Models::Error.new(resp.data_attributes)
          failure_message = "Failure creating the record: %s" % [error.full_messages.inspect]

          Naas::Client.configuration.logger.info { failure_message }

          raise Naas::Errors::InvalidRequestError.new(failure_message)
        end
      end

      # Update an existing campaign
      #
      # @param project_id [String]
      # @param id [String]
      # @param params [Hash]
      #
      # @raises [Naas::InvalidRequestError]
      #
      # @return [Naas::Models::Campaign]
      def self.update_by_project_id(project_id, id, params={})
        request = Naas::Requests::Campaigns.update_by_project_id(project_id, id, params)

        request.on(:success) do |resp|
          return Naas::Models::Campaign.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          error           = Naas::Models::Error.new(resp.data_attributes)
          failure_message = "Failure updating the record: %s" % [error.full_messages.inspect]

          Naas::Client.configuration.logger.info { failure_message }

          raise Naas::Errors::InvalidRequestError.new(failure_message)
        end
      end

      def each(&block)
        internal_collection.each(&block)
      end

      private
      def internal_collection
        @collection.map { |record| Naas::Models::Campaign.new(record) }
      end
    end
  end
end
