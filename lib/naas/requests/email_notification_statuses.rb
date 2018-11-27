module Naas
  module Requests
    class EmailNotificationStatuses

      # Retrieve the instance of an email notification status by
      # email notification
      #
      # @param email_notification_id [Integer]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.retrieve_by_email_notification_id(email_notification_id, params={})
        rel   = Naas::Client.rel_for('rels/email-notification-email-notification-delivery-status')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(email_notification_id: email_notification_id))

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end
    end
  end
end
