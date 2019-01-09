module Naas
  module Models
    class EmailNotificationBasic
      # Helper method to create from the request
      #
      # @param email_address [String]
      # @param project_id [String]
      # @param campaign_id [String]
      # @param campaign_email_template_id [String]
      # @param content [Hash]
      # @param options [Hash]
      #
      # @return [Naas::Models::EmailNotification]
      def self.create(email_address, project_id, campaign_id, campaign_email_template_id, content={}, options={})
        request = Naas::Requests::EmailNotificationBasics.create_from_attributes(email_address, project_id, campaign_id, campaign_email_template_id, content, options)

        klass_attributes = {}

        request.on(:success) do |resp|
          response_body = resp.body
          response_data = response_body.fetch('data', {})

          klass_attributes = response_data
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.info { ("Failure retrieving the email notification: %s" % [resp.status]) }
        end

        Naas::Models::EmailNotification.new(klass_attributes)
      end
    end
  end
end
