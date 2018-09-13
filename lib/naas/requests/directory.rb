module Naas
  module Requests
    class Directory

      def self.retrieve(params={})
        root_url = '/'
        request  = Naas::Client.connection.get do |req|
          req.url(root_url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end
    end
  end
end
