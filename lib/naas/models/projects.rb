module Naas
  module Models
    class Projects
      include Enumerable

      # Return an instance of the projects
      #
      # @param collection [Array]
      #
      # @return [Naas::Models::Projects]
      def initialize(collection)
        @collection = Array(collection)
      end

      # Helper method to retrieve from the
      # request
      #
      # @param params [Hash]
      #
      # @return [Naas::Models::Projects]
      def self.list(params={})
        request = Naas::Requests::Projects.list(params)

        klass_attributes = []

        request.on(:success) do |resp|
          klass_attributes = resp.data_attributes
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.info { ("Failure retrieving the projects: %s" % [resp.status]) }
        end

        self.new(klass_attributes)
      end

      # Helper method to retrieve from the request
      #
      # @param id [String]
      # @param params [Hash]
      #
      # @return [Naas::Models::Project]
      def self.retrieve(id, params={})
        request = Naas::Requests::Projects.retrieve(id, params)

        klass_attributes = {}

        request.on(:success) do |resp|
          klass_attributes = resp.data_attributes
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.info { ("Failure retrieving the project: %s" % [resp.status]) }
        end

        Naas::Models::Project.new(klass_attributes)
      end

      # Retrieve the model from the request
      #
      # @param id [String]
      # @param params [Hash]
      #
      # @raises [Naas::Errors::RecordNotFoundError]
      #
      # @return [Naas::Models::Project]
      def self.retrieve!(id, params={})
        request = Naas::Requests::Projects.retrieve(id, params)

        request.on(:success) do |resp|
          return Naas::Models::Project.new(resp.data_attributes)
        end

        request.on(404) do
          raise Naas::Errors::RecordNotFoundError.new("Could not find record with id: %s" % [id])
        end
      end

      # Create a new project
      #
      # @param params [Hash]
      #
      # @raises [Naas::InvalidRequestError]
      #
      # @return [Naas::Models::Project]
      def self.create(params={})
        request = Naas::Requests::Projects.create(params)

        request.on(:success) do |resp|
          return Naas::Models::Project.new(resp.data_attributes)
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
        @collection.map { |record| Naas::Models::Project.new(record) }
      end
    end
  end
end
