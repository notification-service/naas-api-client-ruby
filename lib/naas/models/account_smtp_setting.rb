module Naas
  module Models
    class AccountSmtpSetting
      include Comparable

      # Returns an instance of the Account SMTP Setting
      #
      #
      # @param attributes [Hash]
      #
      # @return [Naas::Models::AccountSmtpSetting]
      def initialize(attributes={})
        @attributes = attributes
      end

      # Returns the ID
      #
      # @return [Integer]
      def id
        @attributes['id']
      end

      # Returns the name
      #
      # @return [String]
      def name
        @attributes['name']
      end

      # Returns the description
      #
      # @return [String]
      def description
        @attributes['description']
      end

      # Returns the user name
      #
      # @return [String]
      def user_name
        @attributes['user_name']
      end

      # Returns the address
      #
      # @return [String]
      def address
        @attributes['address']
      end

      # Returns the domain
      #
      # @return [String]
      def domain
        @attributes['domain']
      end

      # Returns the port
      #
      # @return [String]
      def port
        @attributes['port']
      end

      # Returns the authentication type value
      #
      # @return [String]
      def authentication_type_value
        @attributes['authentication_type_value']
      end

      # Returns true if start TLS auto is enabled
      #
      # @return [Boolean]
      def is_starttls_auto_enabled
        @attributes['is_starttls_auto_enabled']
      end
      alias :starttls_auto_enabled? :is_starttls_auto_enabled

      # Returns true if this is the primary
      #
      # @return [Boolean]
      def is_primary
        @attributes['is_primary']
      end
      alias :primary? :is_primary

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
