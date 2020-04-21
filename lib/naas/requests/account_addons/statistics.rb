module Naas
  module Requests
    module AccountAddons
      class Statistics

        # Retrieve the aggregate statistics
        #
        # @param id [String]
        # @param params [Hash]
        #
        # @return [Naas::Response]
        def self.retrieve_aggregate(id, params={})
          rel   = Naas::Client.rel_for('rels/account-addon-statistics-aggregate')
          route = Naas::Client.routes.find_by_rel(rel)
          url   = route.url_for(params.merge!(id: id))

          request = Naas::Client.connection.get do |req|
            req.url(url)
            req.headers['Accept'] = 'application/vnd.naas.json; version=1'
          end

          Naas::Response.new(request)
        end
      end
    end
  end
end
