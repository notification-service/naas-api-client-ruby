module Naas
  module Requests
    class Campaigns

      # Retrieve the list of campaigns by project
      #
      # @param project_id [String]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.list_by_project_id(project_id, params={})
        rel   = Naas::Client.rel_for('rels/project-campaigns')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(project_id: project_id))

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Retrieve the instance of a campaign by project
      #
      # @param project_id [String]
      # @param id [String]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.retrieve_by_project_id(project_id, id, params={})
        rel   = Naas::Client.rel_for('rels/project-campaign')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(project_id: project_id, id: id))

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Create a new record
      #
      # @param project_id [String]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.create_by_project_id(project_id, params={})
        rel   = Naas::Client.rel_for('rels/project-campaigns')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(project_id: project_id))

        request_body = {
          :campaign => params
        }

        request = Naas::Client.connection.post do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
          req.body = MultiJson.dump(request_body)
        end

        Naas::Response.new(request)
      end

      # Update an existing record
      #
      # @param project_id [String]
      # @param id [String]
      # @param params [Hash] Attributes for the domain model
      #
      # @return [Naas::Response]
      def self.update_by_project_id(project_id, id, params={})
        rel   = Naas::Client.rel_for('rels/project-campaign')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(project_id: project_id, id: id))

        request_body = {
          :campaign => params
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
