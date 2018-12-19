module Naas
  module Models
    class CampaignEmailTemplates
      include Enumerable

      # Return an instance of the campaigns
      #
      # @param collection [Array]
      #
      # @return [Naas::Models::CampaignEmailTemplates]
      def initialize(collection)
        @collection = Array(collection)
      end

      # Helper method to retrieve from the
      # request
      #
      # @return [Naas::Models::CampaignEmailTemplates]
      def self.list_by_campaign_id(campaign_id, params={})
        request = Naas::Requests::CampaignEmailTemplates.list_by_campaign_id(campaign_id, params)

        klass_attributes = []

        request.on(:success) do |resp|
          response_body = resp.body
          response_data = response_body.fetch('data', [])

          klass_attributes = response_data
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.info { ("Failure retrieving the campaigns: %s" % [resp.status]) }
        end

        self.new(klass_attributes)
      end

      # Helper method to retrieve from the request
      #
      # @return [Naas::Models::CampaignEmailTemplate]
      def self.retrieve_by_campaign_id(campaign_id, id, params={})
        request = Naas::Requests::CampaignEmailTemplates.retrieve_by_campaign_id(campaign_id, id, params)

        klass_attributes = {}

        request.on(:success) do |resp|
          response_body = resp.body
          response_data = response_body.fetch('data', {})

          klass_attributes = response_data
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.info { ("Failure retrieving the campaign: %s" % [resp.status]) }
        end

        Naas::Models::CampaignEmailTemplate.new(klass_attributes)
      end

      # Create a new campaign email template
      #
      # @raises [Naas::InvalidRequestError]
      #
      # @return [Naas::Models::CampaignEmailTemplate]
      def self.create_by_campaign_id(campaign_id, params={})
        request = Naas::Requests::CampaignEmailTemplates.create_by_campaign_id(campaign_id, params)

        request.on(:success) do |resp|
          response_body = resp.body
          response_data = response_body.fetch('data', {})

          klass_attributes = response_data

          return Naas::Models::CampaignEmailTemplate.new(klass_attributes)
        end

        request.on(:failure) do |resp|
          response_body = resp.body
          response_data = response_body.fetch('data', {})

          error           = Naas::Models::Error.new(response_data)
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
        @collection.map { |record| Naas::Models::CampaignEmailTemplate.new(record) }
      end
    end
  end
end
