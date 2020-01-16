module Naas
  module Requests
    class AccountAddons
      # Retrieve the list of Addons
      #
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.list(params={})
        rel   = Naas::Client.rel_for('rels/account-addons')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params)

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Retrieve the instance of an Addon
      #
      # @param id [Integer]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.retrieve(id, params={})
        rel   = Naas::Client.rel_for('rels/account-addon')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(id: id))

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Retrieve the instance of an Addon
      #
      # @param id [Integer]
      # @param params [Hash]
      #
      # @raises [Naas::Errors::RecordNotFoundError]
      #
      # @return [Naas::Response]
      def self.retrieve!(id, params={})
        rel   = Naas::Client.rel_for('rels/account-addon')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(id: id))

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        response = Naas::Response.new(request)

        response.on(:failure) do |resp|
          raise Naas::Errors::RecordNotFoundError.new(resp.body)
        end

        response
      end

      # Update an existing Addon
      #
      # @param id [Integer]
      # @param params [Hash] Attributes for the domain model
      #
      # @raises [Naas::InvalidArgumentError]
      #
      # @return [Naas::Response]
      def self.update(id, params={})
        raise Naas::Errors::InvalidArgumentError.new("id must be provided") if id.nil?
        raise Naas::Errors::InvalidArgumentError.new("params must be a hash") unless params.kind_of?(Hash)

        rel   = Naas::Client.rel_for('rels/account-addon')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(id: id.to_s)

        request_body = {
          :account_addon => params
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
