module Naas
  module Models
    module Auth
      class Profile
        # Returns an instance of the auth  profile
        #
        # @param attributes [Hash]
        #
        # @return [Naas::Models::Auth::Profile]
        def initialize(attributes={})
          @attributes = attributes
        end

        def self.retrieve(params={})
          request = Naas::Requests::Auth::Profile.retrieve

          request.on(:success) do |resp|
            response_body = resp.body
            response_data = response_body.fetch('data', {})

            return self.new(response_data)
          end

          request.on(:failure) do |resp|
            response_body = resp.body
            response_data = response_body.fetch('data', {})

            error = Naas::Models::Error.new(response_data)

            error.errors.each { |error_item| @errors.push(error_item.message) }

            nil
          end
        end

        # Returns the ID of the object
        #
        # @return [String]
        def id
          @attributes['id']
        end

        # Returns the type of the object
        #
        # @todo: We will want to split this to be polymorphic
        # based on the type of User or Account
        #
        # @return [String]
        def type
          @attributes['type']
        end

        # Returns the users first name
        #
        # @context: User
        #
        # @return [String]
        def first_name
          @attributes['first_name']
        end

        # Returns the users last name
        #
        # @context: User
        #
        # @return [String]
        def last_name
          @attributes['last_name']
        end

        # Returns the user's full name
        #
        # @context: User
        #
        # @return [String]
        def full_name
          [self.first_name, self.last_name].compact.join(' ')
        end

        # Returns the users email
        #
        # @context: User
        #
        # @return [String]
        def email
          @attributes['email']
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

        # Returns the updated at timestamp
        #
        # @return [DateTime,NilClass]
        def updated_at
          begin
            DateTime.parse(@attributes['updated_at'])
          rescue
            nil
          end
        end

        # Returns the links attributes
        #
        # @return [Array]
        def links_attributes
          @attributes.fetch('links', [])
        end

        # Returns the Links
        #
        # @return [Naas::Models::Links]
        def links
          @links ||= Naas::Models::Links.new(self.links_attributes)
        end

        # Returns true if there are any links
        #
        # @return [Boolean]
        def links?
          self.links.any?
        end
      end
    end
  end
end
