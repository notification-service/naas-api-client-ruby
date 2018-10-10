module Naas
  module Models
    class Subscriber
      include Comparable

      # Returns an instance of the Subscriber
      #
      # @param attributes [Hash]
      #
      # @return [Naas::Models::Subscriber]
      def initialize(attributes={})
        @attributes = attributes
      end

      #
      # @return [Integer]
      def id
        @attributes['id']
      end

      # Returns the first name
      #
      # @return [String]
      def first_name
        @attributes['first_name']
      end

      # Returns the last name
      #
      # @return [String]
      def last_name
        @attributes['last_name']
      end

      # Returns the full name
      #
      # @return [String]
      def full_name
        [self.first_name, self.last_name].compact.join(' ')
      end

      # Returns the primary email address value
      #
      # @return [String]
      def email_address
        @attributes['email_address']
      end

      # Returns true if there is an email address
      #
      # @return [Boolean]
      def email_address?
        !self.email_address.nil? && !self.email_address.empty?
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
