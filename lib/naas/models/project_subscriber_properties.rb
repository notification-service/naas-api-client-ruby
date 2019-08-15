module Naas
  module Models
    class ProjectSubscriberProperties
      include Enumerable

      # Returns an instance of the project subscriber properties
      #
      # @param collection [Array]
      #
      # @return [Naas::Models::ProjectSubscriberProperties]
      def initialize(collection)
        @collection = Array(collection)
      end

      # Retrieve the list of subscribers properties by project
      #
      # @param project_id [String]
      # @param project_subscriber_id [String]
      # @param params [Hash]
      #
      # @return [Naas::Models::ProjectSubscriberProperties]
      def self.list_by_project_id_and_project_subscriber_id(project_id, project_subscriber_id, params={})
        request = Naas::Requests::ProjectSubscriberProperties.list_by_project_id_and_project_subscriber_id(project_id, project_subscriber_id, params)

        request.on(:success) do |resp|
          return Naas::Models::ProjectSubscriberProperties.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the property subscriber properties: %s" % [resp.status]) }

          nil
        end
      end

      # Retrieve the instance of a project subscriber property by project
      #
      # @param project_id [String]
      # @param project_subscriber_id [String]
      # @param id [String]
      # @param params [Hash]
      #
      # @return [Naas::Models::ProjectSubscriberProperty]
      def self.retrieve_by_project_id_and_project_subscriber_id(project_id, project_subscriber_id, id, params={})
        request = Naas::Requests::ProjectSubscriberProperties.retrieve_by_project_id_and_project_subscriber_id(project_id, project_subscriber_id, id, params)

        request.on(:success) do |resp|
          return Naas::Models::ProjectSubscriberProperty.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the project subscriber property: %s" % [resp.status]) }

          return nil
        end
      end

      # Create a new record
      #
      # @param project_id [String]
      # @param project_subscriber_id [String]
      # @param params [Hash]
      #
      # @return [Naas::Models::ProjectSubscriberProperty]
      def self.create_by_project_id_and_project_subscriber_id(project_id, project_subscriber_id, params={})
        request = Naas::Requests::ProjectSubscriberProperties.create_by_project_id_and_project_subscriber_id(project_id, project_subscriber_id, params)

        request.on(:success) do |resp|
          return Naas::Models::ProjectSubscriberProperty.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          error           = Naas::Models::Error.new(resp.data_attributes)
          failure_message = "Failure creating the record: %s" % [error.full_messages.inspect]

          Naas::Client.configuration.logger.error { failure_message }

          raise Naas::Errors::InvalidRequestError.new(failure_message)
        end
      end

      # Update an existing record
      #
      # @param project_id [String]
      # @param project_subscriber_id [String]
      # @param id [String]
      # @param params [Hash]
      #
      # @return [Naas::Models::ProjectSubscriberProperty]
      def self.update_by_project_id_and_project_subscriber_id(project_id, project_subscriber_id, id, params={})
        request = Naas::Requests::ProjectSubscriberProperties.update_by_project_id_and_project_subscriber_id(project_id, project_subscriber_id, id, params)

        request.on(:success) do |resp|
          return Naas::Models::ProjectSubscriberProperty.new(resp.data_attributes)
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
        @collection.map { |record| Naas::Models::ProjectSubscriberProperty.new(record) }
      end
    end
  end
end
