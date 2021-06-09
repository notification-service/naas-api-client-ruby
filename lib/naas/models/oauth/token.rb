module Naas
  module Models
    module Oauth
      class Token

        # Returns an instance of the Oauth Token
        #
        # @params attributes [Hash]
        #
        # @return [Naas::Models::Oauth::Token]
        def initialize(attributes={})
          @attributes = attributes
        end

        def self.refresh(token, params={})
          request = Naas::Requests::Oauth::Token.refresh(token, params)

          request.on(:success) do |resp|
            response_body = resp.body

            return self.new(response_body)
          end

          request.on(:failure) do |resp|
            response_body = resp.body

            error = Naas::Models::Oauth::Error.new(response_body)

            return nil
          end
        end

        def self.create(params={})
          request = Naas::Requests::Oauth::Token.create(params)

          request.on(:success) do |resp|
            response_body = resp.body

            return self.new(response_body)
          end

          request.on(:failure) do |resp|
            response_body = resp.body

            error = Naas::Models::Oauth::Error.new(response_body)

            return nil
          end
        end

        def self.retrieve(token, params={})
          request = Naas::Requests::Oauth::Token.retrieve(token, params)

          request.on(:success) do |resp|
            response_body = resp.body

            return self.new(response_body)
          end

          request.on(:failure) do |resp|
            response_body = resp.body

            error = Naas::Models::Oauth::Error.new(response_body)

            return nil
          end
        end

        def self.revoke(token, params={})
          request = Naas::Requests::Oauth::Token.revoke(token, params)

          request.on(:success) do |resp|
            response_body = resp.body

            return nil
          end

          request.on(:failure) do |resp|
            response_body = resp.body

            error = Naas::Models::Oauth::Error.new(response_body)

            return nil
          end
        end

        def token_type
          @attributes['token_type']
        end

        def access_token
          @attributes['access_token']
        end

        def retrieve
          self.class.retrieve(self.access_token)
        end

        def revoke
          self.class.revoke(self.access_token)
        end

        def refresh_token
          @attributes['refresh_token']
        end

        def expires_in
          @attributes['expires_in'].to_i
        end

        def scope
          @attributes.fetch('scope', [])
        end

        # Returns the created at timestamp
        #
        # @return [DateTime,NilClass]
        def created_at
          begin
            DateTime.parse(@attributes['created_at'])
          rescue
            nil
          end
        end

      end
    end
  end
end
