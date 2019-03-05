module Naas
  module Requests
    class EmailNotificationBasics
      # Create a new record
      #
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.create(params={})
        rel   = Naas::Client.rel_for('rels/email-notification-basic')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for

        request_body = {
          :email_notification_basic => params
        }

        request = Naas::Client.connection.post do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
          req.body = MultiJson.dump(request_body)
        end

        Naas::Response.new(request)
      end

      # Provides a simpler set of arguments to create
      # the basic notification
      #
      # @param email_address [String]
      # @param project_id [String]
      # @param campaign_id [String]
      # @param campaign_email_template_id [String]
      # @param content [Hash]
      # @param options [Hash]
      #
      # @return [Naas::Response]
      def self.create_from_attributes(email_address, project_id, campaign_id, campaign_email_template_id, content={}, options={})
        record_attributes = {
          :email_address              => email_address,
          :project_id                 => project_id,
          :campaign_id                => campaign_id,
          :campaign_email_template_id => campaign_email_template_id,
          :content                    => content,
        }

        record_attributes.merge!(tags: options.fetch(:tags, {}))

        if options.has_key?(:account_smtp_setting_id)
          record_attributes.merge!(account_smtp_setting_id: options[:account_smtp_setting_id])
        end

        self.create(record_attributes)
      end
    end
  end
end
