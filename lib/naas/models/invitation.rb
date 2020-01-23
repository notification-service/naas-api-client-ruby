module Naas
  module Models
    class Invitation
      include Comparable

      # Returns an instance of the Invitation
      #
      # @param attributes [Hash]
      #
      # @return [Naas::Models::Invitation]
      def initialize(attributes={})
        @attributes = attributes
      end

      # Returns the ID
      #
      # @return [String]
      def id
        @attributes['id']
      end

      # Returns the account addon id
      #
      # @return [Integer]
      def account_addon_id
        @attributes['account_addon_id']
      end

      # Returns the subscriber id
      #
      # @return [Integer]
      def subscriber_id
        @attributes['subscriber_id']
      end

      # Returns the recipient
      #
      # @return [String]
      def recipient
        @attributes['recipient']
      end

      # Returns the code
      #
      # @return [String]
      def code
        @attributes['code']
      end

      # Returns true if this is pending
      #
      # @return [Boolean]
      def is_pending
        @attributes['is_pending']
      end
      alias is_pending? is_pending
      alias pending? is_pending

      # returns true if this is accepted
      #
      # @return [Boolean]
      def is_accepted
        @attributes['is_accepted']
      end
      alias is_accepted? is_accepted
      alias accepted? is_accepted

      # Returns true if this is declined
      #
      # @return [Boolean]
      def is_declined
        @attributes['is_declined']
      end
      alias is_declined? is_declined
      alias declined? is_declined

      # Returns the accepted at timestamp
      #
      # @return [DateTime,NilClass]
      def accepted_at
        begin
          DateTime.parse(@attributes['accepted_at'])
        rescue
          nil
        end
      end

      # Returns the declined at timestamp
      #
      # @return [DateTime,NilClass]
      def declined_at
        begin
          DateTime.parse(@attributes['declined_at'])
        rescue
          nil
        end
      end

      # Returns the created at timestamp
      #
      # @return [DateTime]
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

      # Returns the record as an array
      #
      # @return [Array]
      def to_a
        [self.id, self.recipient, self.created_at, self.accepted_at, self.declined_at]
      end
    end
  end
end
