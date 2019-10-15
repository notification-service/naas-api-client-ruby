module Naas
  module Models
    class AccountAssets
      include Enumerable

      # Return an instance of the Account Assets
      #
      # @param collection [Array]
      #
      # @return [Naas::Models::AccountAssets]
      def initialize(collection)
        @collection = Array(collection)
      end

      # Helper method to list all from the request
      #
      # @param params [Hash]
      #
      # @return [Naas::Models::AccountAssets]
      def self.list(params={})
        request = Naas::Requests::AccountAssets.list(params)

        klass_attributes = []

        request.on(:success) do |resp|
          klass_attributes = resp.data_attributes
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the account assets: %s" % [resp.status]) }
        end

        self.new(klass_attributes)
      end

      # Helper method to retrieve from the request
      #
      # @param id [String]
      # @param params [Hash]
      #
      # @return [Naas::Models::AccountAsset,NilClass]
      def self.retrieve(id, params={})
        request = Naas::Requests::AccountAssets.retrieve(id, params)

        request.on(:success) do |resp|
          return Naas::Models::AccountAsset.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the account asset: %s" % [resp.status]) }

          return nil
        end
      end

      # Helper method to create from the request
      #
      # @param params [Hash]
      #
      # @raises [Naas::InvalidRequestError]
      #
      # @return [Naas::Models::AccountAsset]
      def self.create(params={})
        request = Naas::Requests::AccountAssets.create(params)

        request.on(:success) do |resp|
          return Naas::Models::AccountAsset.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          error           = Naas::Models::Error.new(resp.data_attributes)
          failure_message = "Failure creating the record: %s" % [error.full_messages.inspect]

          Naas::Client.configuration.logger.error { failure_message }

          raise Naas::Errors::InvalidRequestError.new(failure_message)
        end
      end

      # Helper method to create from file content
      #
      # @param file_content [String]
      # @param mime_type [String]
      # @param params [Hash]
      #
      # @raises [Naas::Errors::InvalidFileError]
      #
      # @return [Naas::Models::AccountAsset]
      def self.create_from_file_content(file_content, mime_type, params={})
        request = Naas::Requests::AccountAssets.create_from_file_content(file_content, mime_type, params)

        request.on(:success) do |resp|
          return Naas::Models::AccountAsset.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          error           = Naas::Models::Error.new(resp.data_attributes)
          failure_message = "Failure creating the record: %s" % [error.full_messages.inspect]

          Naas::Client.configuration.logger.error { failure_message }

          raise Naas::Errors::InvalidRequestError.new(failure_message)
        end
      end

      # Helper method to create from file
      #
      # @param file [File,IO]
      # @param mime_type [String]
      # @param params [Hash]
      #
      # @raises [Naas::Errors::InvalidFileError]
      #
      # @return [Naas::Models::AccountAsset]
      def self.create_from_file(file, mime_type, params={})
        request = Naas::Requests::AccountAssets.create_from_file(file, mime_type, params)

        request.on(:success) do |resp|
          return Naas::Models::AccountAsset.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          error           = Naas::Models::Error.new(resp.data_attributes)
          failure_message = "Failure creating the record: %s" % [error.full_messages.inspect]

          Naas::Client.configuration.logger.error { failure_message }

          raise Naas::Errors::InvalidRequestError.new(failure_message)
        end
      end

      # Helper method to create from file path
      #
      # @param file_path [String,Pathname]
      # @param mime_type [String]
      # @param params [Hash]
      #
      # @raises [Naas::Errors::InvalidFileError]
      #
      # @return [Naas::Models::AccountAsset]
      def self.create_from_file_path(file_path, mime_type, params={})
        request = Naas::Requests::AccountAssets.create_from_file_path(file_path, mime_type, params)

        request.on(:success) do |resp|
          return Naas::Models::AccountAsset.new(resp.data_attributes)
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
        @collection.map { |record| Naas::Models::AccountAsset.new(record) }
      end
    end
  end
end
