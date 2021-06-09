module Naas
  module Models
    module Oauth
      class Error

        # Returns an instance of the Oauth Error domain model
        #
        # @param attributes [Hash]
        #
        # @return [Naas::Models::Oauth::Error]
        def initialize(attributes={})
          @attributes = attributes
        end

        # Returns the error
        #
        # @return [String]
        def error
          @attributes['error']
        end

        # Returns the error description
        #
        # @return [String]
        def error_description
          @attributes['error_description']
        end
        alias description error_description

        # Returns the error uri
        #
        # @return [String]
        def error_uri
          @attributes['error_uri']
        end
        alias uri error_uri
      end
    end
  end
end
