module Naas
  module Requests
    module AccountAddon
      class Statistics

        # Retrieve the aggregate statistics
        #
        # @param id [String]
        # @param params [Hash]
        #
        # @return [Naas::Response]
        def self.retrieve_aggregate(id, params={}, options={})
          default_options = {
            :accept => 'application/vnd.naas.json; version=1'
          }

          core_options = default_options.merge!(options)

          rel   = Naas::Client.rel_for('rels/account-addon-statistics-aggregate')
          route = Naas::Client.routes.find_by_rel(rel)
          url   = route.url_for(params.merge!(account_addon_id: id))

          request = Naas::Client.connection.get do |req|
            req.url(url)
            req.headers['Accept'] = core_options[:accept]
          end

          Naas::Response.new(request)
        end

        # Retrieve the network graph
        #
        # @param id [String]
        # @param params [Hash]
        #
        # @return [Naas::Response]
        def self.retrieve_network_graph(id, params={}, options={})
          default_options = {
            :accept => 'application/vnd.naas.json; version=1'
          }

          core_options = default_options.merge!(options)

          rel   = Naas::Client.rel_for('rels/account-addon-statistics-network-graph')
          route = Naas::Client.routes.find_by_rel(rel)
          url   = route.url_for(params.merge!(account_addon_id: id))

          request = Naas::Client.connection.get do |req|
            req.url(url)
            req.headers['Accept'] = core_options[:accept]
          end

          Naas::Response.new(request)
        end

        # Retrieve the network top performers
        #
        # @param id [String]
        # @param params [Hash]
        #
        # @return [Naas::Response]
        def self.retrieve_network_performers(id, params={}, options={})
          default_options = {
            :accept => 'application/vnd.naas.json; version=1'
          }

          core_options = default_options.merge!(options)

          rel   = Naas::Client.rel_for('rels/account-addon-statistics-network-performers')
          route = Naas::Client.routes.find_by_rel(rel)
          url   = route.url_for(params.merge!(account_addon_id: id))

          request = Naas::Client.connection.get do |req|
            req.url(url)
            req.headers['Accept'] = core_options[:accept]
          end

          Naas::Response.new(request)
        end
      end
    end
  end
end
