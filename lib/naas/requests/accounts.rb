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
    end
  end
end
