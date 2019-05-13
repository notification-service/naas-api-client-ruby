module Naas
  module Requests
    class Accounts
      # Retrieve the current account
      #
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.retrieve(params={})
        rel   = Naas::Client.rel_for('rels/account')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Update the current account
      #
      # @param params [Hash] Attributes for the domain model
      #
      # @return [Naas::Response]
      def self.update(params={})
        raise Naas::Errors::InvalidArgumentError.new("params must be a hash") unless params.kind_of?(Hash)

        rel   = Naas::Client.rel_for('rels/account')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for

        request_body = {
          :account => params
        }

        request = Naas::Client.connection.put do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
          req.headers['Content-Type'] = 'application/json'
          req.body = MultiJson.dump(request_body)
        end

        Naas::Response.new(request)
      end

      # Destroy data for the account
      #
      # @note: This is only supported with a valid test token
      #
      # @return [Naas::Response]
      def self.destroy_data
        rel   = Naas::Client.rel_for('rels/account-data')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for

        request = Naas::Client.connection.delete do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end
    end
  end
end
