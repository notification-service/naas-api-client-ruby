module Naas
  module Models
    class AccountSmtpSettings
      include Enumerable

      # Return an instance of the smtp settings
      #
      # @param collection [Array]
      #
      # @return [Naas::Models::AccountSmtpSettings]
      def initialize(collection)
        @collection = Array(collection)
      end

      # Helper method to retrieve from the
      # request
      #
      # @param params [Hash]
      #
      # @return [Naas::Models::AccountSmtpSettings]
      def self.list(params={})
        request = Naas::Requests::AccountSmtpSettings.list(params)

        klass_attributes = []

        request.on(:success) do |resp|
          klass_attributes = resp.data_attributes
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the smtp settings: %s" % [resp.status]) }
        end

        self.new(klass_attributes)
      end

      # Helper method to retrieve from the request
      #
      # @param id [String]
      # @param params [Hash]
      #
      # @return [Naas::Models::AccountSmtpSetting]
      def self.retrieve(id, params={})
        request = Naas::Requests::AccountSmtpSettings.retrieve(id, params)

        request.on(:success) do |resp|
          return Naas::Models::AccountSmtpSetting.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the smtp setting: %s" % [resp.status]) }

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
      # @return [Naas::Models::AccountSmtpSetting]
      def self.retrieve!(id, params={})
        request = Naas::Requests::AccountSmtpSettings.retrieve(id, params)

        request.on(:success) do |resp|
          return Naas::Models::AccountSmtpSetting.new(resp.data_attributes)
        end

        request.on(404) do
          raise Naas::Errors::RecordNotFoundError.new("Could not find record with id: %s" % [id])
        end
      end

      # Create a new SMTP setting
      #
      # @param params [Hash]
      #
      # @raises [Naas::InvalidRequestError]
      #
      # @return [Naas::Models::AccountSmtpSetting]
      def self.create(params={})
        request = Naas::Requests::AccountSmtpSettings.create(params)

        request.on(:success) do |resp|
          return Naas::Models::AccountSmtpSetting.new(resp.data_attributes)
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
        @collection.map { |record| Naas::Models::AccountSmtpSetting.new(record) }
      end
    end
  end
end
