module Naas
  module Requests
    class CampaignEmailTemplates
      # Retrieve the list of a campaign email template by campaign
      #
      # @param campaign_id [Integer]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.list_by_campaign_id(campaign_id, params={})
        rel   = Naas::Client.rel_for('rels/campaign-campaign-email-templates')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(campaign_id: campaign_id))

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Retrieve the instance of a campaign email template by campaign
      #
      # @param campaign_id [Integer]
      # @param id [Integer]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.retrieve_by_campaign_id(campaign_id, id, params={})
        rel   = Naas::Client.rel_for('rels/campaign-campaign-email-template')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(campaign_id: campaign_id, id: id))

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Create a new record
      #
      # @param id [Integer]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.create_by_campaign_id(campaign_id, params={})
        rel   = Naas::Client.rel_for('rels/campaign-campaign-email-templates')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(campaign_id: campaign_id))

        request_body = {
          :campaign_email_template => params
        }

        request = Naas::Client.connection.post do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
          req.body = MultiJson.dump(request_body)
        end

        Naas::Response.new(request)
      end
    end
  end
end
