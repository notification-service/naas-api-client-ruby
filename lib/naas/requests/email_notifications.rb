module Naas
  module Requests
    class EmailNotifications
      # Retrieve the list of email notifications
      #
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.list(params={})
        rel   = Naas::Client.rel_for('rels/email-notifications')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Retrieve the instance of a email notification
      #
      # @param id [Integer]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.retrieve(id, params={})
        rel   = Naas::Client.rel_for('rels/email-notification')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(id: id))

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Update an existing record
      #
      # @param id [Integer]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.update(id, params={})
        rel   = Naas::Client.rel_for('rels/email-notification')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(id: id))

        request_body = {
          :email_notification => params
        }

        request = Naas::Client.connection.put do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
          req.body = MultiJson.dump(request_body)
        end

        Naas::Response.new(request)
      end

      # Deliver the instance of a email notification
      #
      # @param id [Integer]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.deliver(id, params={})
        rel   = Naas::Client.rel_for('rels/email-notification-deliver')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(id: id))

        request = Naas::Client.connection.post do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Preview the instance of a email notification
      #
      # @param id [Integer]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.preview_html(id, params={})
        rel   = Naas::Client.rel_for('rels/email-notification-preview')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(id: id))

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.html; version=1'
        end

        Naas::Response.new(request)
      end
    end
  end
end
