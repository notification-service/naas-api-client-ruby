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
      # @param project_id [String]
      # @param campaign_id [String]
      # @param params [Hash]
      #
      # @return [Naas::Models::CampaignEmailTemplates]
      def self.list_by_project_id_and_campaign_id(project_id, campaign_id, params={})
        request = Naas::Requests::CampaignEmailTemplates.list_by_project_id_and_campaign_id(project_id, campaign_id, params)

        klass_attributes = []

        request.on(:success) do |resp|
          klass_attributes = resp.data_attributes
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the email templates: %s" % [resp.status]) }
        end

        self.new(klass_attributes)
      end

      # Helper method to retrieve from the request
      #
      # @param project_id [String]
      # @param campaign_id [String]
      # @param id [String]
      # @param params [Hash]
      #
      # @return [Naas::Models::CampaignEmailTemplate]
      def self.retrieve_by_project_id_and_campaign_id(project_id, campaign_id, id, params={})
        request = Naas::Requests::CampaignEmailTemplates.retrieve_by_project_id_and_campaign_id(project_id, campaign_id, id, params)

        request.on(:success) do |resp|
          return Naas::Models::CampaignEmailTemplate.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the email template: %s" % [resp.status]) }

          return nil
        end
      end

      # Helper method to retrieve from the request
      #
      # @param project_id [String]
      # @param campaign_id [String]
      # @param id [String]
      # @param params [Hash]
      #
      # @raises [Naas::Errors::RecordNotFoundError]
      #
      # @return [Naas::Models::CampaignEmailTemplate]
      def self.retrieve_by_project_id_and_campaign_id!(project_id, campaign_id, id, params={})
        request = Naas::Requests::CampaignEmailTemplates.retrieve_by_project_id_and_campaign_id(project_id, campaign_id, id, params)

        request.on(:success) do |resp|
          return Naas::Models::CampaignEmailTemplate.new(resp.data_attributes)
        end

        request.on(404) do
          raise Naas::Errors::RecordNotFoundError.new("Could not find record with id: %s" % [id])
        end
      end

      # Create a new campaign email template
      #
      # @param project_id [String]
      # @param campaign_id [String]
      #
      # @raises [Naas::InvalidRequestError]
      #
      # @return [Naas::Models::CampaignEmailTemplate]
      def self.create_by_project_id_and_campaign_id(project_id, campaign_id, params={})
        request = Naas::Requests::CampaignEmailTemplates.create_by_project_id_and_campaign_id(project_id, campaign_id, params)

        request.on(:success) do |resp|
          return Naas::Models::CampaignEmailTemplate.new(resp.data_attributes)
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
        @collection.map { |record| Naas::Models::CampaignEmailTemplate.new(record) }
      end
    end
  end
end
