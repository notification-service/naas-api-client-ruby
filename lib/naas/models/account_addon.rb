module Naas
  module Models
    class AccountAddon
      include Comparable

      # Returns an instance of the Account Addon
      #
      #
      # @param attributes [Hash]
      #
      # @return [Naas::Models::AccountAddon]
      def initialize(attributes={})
        @attributes = attributes
      end

      # Returns the ID
      #
      # @return [Integer]
      def id
        @attributes['id']
      end

      # Returns the addon ID
      #
      # @return [Integer]
      def addon_id
        @attributes['addon_id']
      end

      # Returns the attributes for the addon
      #
      # @return [Hash]
      def addon_attributes
        @attributes.fetch('addon', {})
      end

      # Returns true if there are any addon attributes
      #
      # @return [Boolean]
      def addon_attributes?
        !self.addon_attributes.empty?
      end

      # Returns the associated addon
      #
      # @return [Naas::Models::Addon]
      def addon
        @addon ||= if self.addon_attributes?
                     Naas::Models::Addon.new(self.addon_attributes)
                   else
                     Naas::Models::Addons.retrieve(self.addon_id)
                   end
      end

      # Returns true if there is an addon
      #
      # @return [Boolean]
      def addon?
        !self.addon.nil?
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
