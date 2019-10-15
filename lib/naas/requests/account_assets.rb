module Naas
  module Requests
    class AccountAssets
      # Retrieve the list of account assets
      #
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.list(params={})
        rel   = Naas::Client.rel_for('rels/account-assets')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params)

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Retrieve the instance of a account asset
      #
      # @param id [Integer]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.retrieve(id, params={})
        rel   = Naas::Client.rel_for('rels/account-asset')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(id: id))

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Retrieve the file content for an account asset
      #
      # @param token [String]
      # @param system_filename [String]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.retrieve_file(token, system_filename, params={})
        rel   = Naas::Client.rel_for('rels/account-asset-file')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(token: token, system_filename: system_filename)

        request = Naas::Client.connection.get do |req|
          req.url(url)
        end

        Naas::Response.new(request)
      end
    end
  end
end
