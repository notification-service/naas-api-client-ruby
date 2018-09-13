module Naas
  module Requests
    class Projects
      REL_PATH = 'rels/projects'.freeze

      # Retrieve the rel with the API host
      #
      # @return [String]
      def self.rel
        Naas::Client.rel_for(REL_PATH)
      end

      # Retrieve the list of projects
      #
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.list(params={})
        route = Naas::Client.routes.find_by_rel(self.rel)
        url   = route.url_for

        request  = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end
    end
  end
end
