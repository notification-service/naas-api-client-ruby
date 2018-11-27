module Naas
  module Requests
    class EmailNotificationDeliveries

      # Retrieve the list of deliveries by the email notification
      #
      # @param email_notification_id [Integer]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.list_by_email_notification_id(email_notification_id, params={})
        rel   = Naas::Client.rel_for('rels/email-notification-email-notification-deliveries')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(email_notification_id: email_notification_id))

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Retrieve the instance of an email notification delivery by
      # email notification
      #
      # @param email_notification_id [Integer]
      # @param id [Integer]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.retrieve_by_email_notification_id(email_notification_id, id, params={})
        rel   = Naas::Client.rel_for('rels/email-notification-email-notification-delivery')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(email_notification_id: email_notification_id, id: id))

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end
    end
  end
end
