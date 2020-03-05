module Naas
  module Requests
    class Invitations
      # Retrieve the list of invitations
      #
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.list(params={})
        rel   = Naas::Client.rel_for('rels/invitations')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params)

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Retrieve the instance of a invitation
      #
      # @param id [String]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.retrieve(id, params={})
        raise Naas::Errors::InvalidArgumentError.new("id must be provided") if id.nil?

        rel   = Naas::Client.rel_for('rels/invitation')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(id: id.to_s))

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Accept the invitation
      #
      # @param id [String]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.accept(id, params={})
        raise Naas::Errors::InvalidArgumentError.new("id must be provided") if id.nil?

        rel   = Naas::Client.rel_for('rels/invitation-accept')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(id: id.to_s))

        request = Naas::Client.connection.post do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Decline the invitation
      #
      # @param id [String]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.decline(id, params={})
        raise Naas::Errors::InvalidArgumentError.new("id must be provided") if id.nil?

        rel   = Naas::Client.rel_for('rels/invitation-decline')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(id: id.to_s))

        request = Naas::Client.connection.post do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end
    end
  end
end
