module Naas
  module Requests
    class ProjectSubscriberProfiles

      # Retrieve the instance of a project subscriber by project
      #
      # @param project_id [String]
      # @param project_subscriber_id [String]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.retrieve_by_project_id_and_project_subscriber_id(project_id, project_subscriber_id, params={})
        rel   = Naas::Client.rel_for('rels/project-subscriber-profile')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(project_id: project_id, project_subscriber_id: project_subscriber_id))

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Update existing record
      #
      # @param project_id [String]
      # @param project_subscriber_id [String]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.update_by_project_id_and_project_subscriber_id(project_id, project_subscriber_id, params={})
        rel   = Naas::Client.rel_for('rels/project-subscriber-profile')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(project_id: project_id, project_subscriber_id: project_subscriber_id))

        request_body = params

        request = Naas::Client.connection.put do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
          req.body = MultiJson.dump(request_body)
        end

        Naas::Response.new(request)
      end
    end
  end
end
