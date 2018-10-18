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
      # @return [Naas::Models::AccountSmtpSettings]
      def self.list(params={})
        request = Naas::Requests::AccountSmtpSettings.list(params)

        klass_attributes = []

        request.on(:success) do |resp|
          response_body = resp.body
          response_data = response_body.fetch('data', [])

          klass_attributes = response_data
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.info { ("Failure retrieving the smtp settings: %s" % [resp.status]) }
        end

        self.new(klass_attributes)
      end

      # Helper method to retrieve from the request
      #
      # @return [Naas::Models::AccountSmtpSetting]
      def self.retrieve(id, params={})
        request = Naas::Requests::AccountSmtpSettings.retrieve(id, params)

        klass_attributes = {}

        request.on(:success) do |resp|
          response_body = resp.body
          response_data = response_body.fetch('data', {})

          klass_attributes = response_data
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.info { ("Failure retrieving the smtp setting: %s" % [resp.status]) }
        end

        Naas::Models::AccountSmtpSetting.new(klass_attributes)
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