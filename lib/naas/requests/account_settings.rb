module Naas
  module Requests
    class AccountSettings
      # Retrieve the current account settings
      #
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.retrieve(params={})
        rel   = Naas::Client.rel_for('rels/account-settings')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Update the current account settings
      #
      # @param params [Hash] Attributes for the domain model
      #
      # @return [Naas::Response]
      def self.update(params={})
        rel   = Naas::Client.rel_for('rels/account-settings')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for

        request_body = {
          :account_settings => params
        }

        request = Naas::Client.connection.put do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
          req.headers['Content-Type'] = 'application/json'
          req.body = MultiJson.dump(request_body)
        end

        Naas::Response.new(request)
      end
    end
  end
end
