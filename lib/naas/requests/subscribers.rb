module Naas
  module Requests
    class Subscribers
      # Retrieve the list of subscribers
      #
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.list(params={})
        rel   = Naas::Client.rel_for('rels/subscribers')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params)

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Retrieve the instance of a subscriber
      #
      # @param id [Integer]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.retrieve(id, params={})
        rel   = Naas::Client.rel_for('rels/subscriber')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(id: id))

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Create a new subscriber
      #
      # @param params [Hash] Attributes for the domain model
      #
      # @return [Naas::Response]
      def self.create(params={})
        rel   = Naas::Client.rel_for('rels/subscribers')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for

        request_body = {
          :subscriber => params
        }

        request = Naas::Client.connection.post do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
          req.headers['Content-Type'] = 'application/json'
          req.body = MultiJson.dump(request_body)
        end

        Naas::Response.new(request)
      end

      # Update an existing subscriber
      #
      # @param id [Integer]
      # @param params [Hash] Attributes for the domain model
      #
      # @return [Naas::Response]
      def self.update(id, params={})
        rel   = Naas::Client.rel_for('rels/subscriber')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(id: id)

        request_body = {
          :subscriber => params
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
