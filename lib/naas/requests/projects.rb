module Naas
  module Requests
    class Projects
      # Retrieve the list of projects
      #
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.list(params={})
        rel   = Naas::Client.rel_for('rels/projects')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params)

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Retrieve the instance of a project
      #
      # @param id [Integer]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.retrieve(id, params={})
        rel   = Naas::Client.rel_for('rels/project')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(id: id))

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Create a new project
      #
      # @param params [Hash] Attributes for the domain model
      #
      # @raises [Naas::InvalidArgumentError]
      #
      # @return [Naas::Response]
      def self.create(params={})
        raise Naas::Errors::InvalidArgumentError.new("params must be a hash") unless params.kind_of?(Hash)

        rel   = Naas::Client.rel_for('rels/projects')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for

        request_body = {
          :project => params
        }

        request = Naas::Client.connection.post do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
          req.headers['Content-Type'] = 'application/json'
          req.body = MultiJson.dump(request_body)
        end

        Naas::Response.new(request)
      end

      # Update an existing project
      #
      # @param id [Integer]
      # @param params [Hash] Attributes for the domain model
      #
      # @raises [Naas::InvalidArgumentError]
      #
      # @return [Naas::Response]
      def self.update(id, params={})
        raise Naas::Errors::InvalidArgumentError.new("params must be a hash") unless params.kind_of?(Hash)

        rel   = Naas::Client.rel_for('rels/project')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(id: id)

        request_body = {
          :project => params
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
