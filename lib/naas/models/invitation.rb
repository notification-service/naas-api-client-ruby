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

      # Returns the account addon attributes
      #
      # @return [Hash]
      def account_addon_attributes
        @attributes.fetch('account_addon', {})
      end

      # Returns true if there are account addon attributes
      #
      # @return [Boolean]
      def account_addon_attributes?
        !self.account_addon_attributes.nil? && !self.account_addon_attributes.empty?
      end

      # Returns the associated Account Addon
      #
      # @return [Naas::Models::AccountAddon]
      def account_addon
        @account_addon ||= if self.account_addon_attributes?
                             Naas::Models::AccountAddon.new(self.account_addon_attributes)
                           else
                             Naas::Models::AccountAddons.retrieve(self.account_addon_id)
                           end
      end

      # Returns the subscriber id
      #
      # @return [Integer]
      def subscriber_id
        @attributes['subscriber_id']
      end

      # Returns the subscriber attributes
      #
      # @return [Hash]
      def subscriber_attributes
        @attributes.fetch('subscriber', {})
      end

      # Returns true if there are subscriber attributes
      #
      # @return [Boolean]
      def subscriber_attributes?
        !self.subscriber_attributes.nil? && !self.subscriber_attributes.empty?
      end

      # Returns the associated subscriber
      #
      # @return [Naas::Models::Subscriber]
      def subscriber
        @subscriber ||= if self.subscriber_attributes?
                          Naas::Models::Subscriber.new(self.subscriber_attributes)
                        else
                          Naas::Models::Subscribers.retrieve(self.subscriber_id)
                        end
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

      # Returns the email notification route
      #
      # @return [Naas::Models::Link]
      def email_notification_route
        rel   = Naas::Client.rel_for('rels/email-notification')
        route = self.links.find_by_rel(rel)

        route
      end

      # Returns true if there is an email notification route
      #
      # @return [Boolean]
      def email_notification_route?
        !self.email_notification_route.nil?
      end

      # Returns the email notification request
      #
      # @return [Naas::Response]
      def email_notification_request
        if self.email_notification_route?
          request = Naas::Client.connection.get do |req|
            req.url(self.email_notification_route.url_for)
            req.headers['Accept'] = 'application/vnd.naas.json; version=1'
          end

          Naas::Response.new(request)
        end
      end

      # Returns true if there is an email notification request
      #
      # @return [Boolean]
      def email_notification_request?
        !self.email_notification_request.nil?
      end

      # Returns the association email notification
      #
      # @return [Naas::Models::EmailNotification,NilClass]
      def email_notification
        return @email_notification if @email_notification

        @email_notification = nil

        if self.email_notification_request?
          self.email_notification_request.on(:success) do |resp|
            @email_notification = Naas::Models::EmailNotification.new(resp.data_attributes)
          end
        end

        @email_notification
      end

      # Returns true if there is an email notifcation object
      #
      # @return [Boolean]
      def email_invitation?
        !self.email_invitation.nil?
      end

      # Returns the record as an array
      #
      # @return [Array]
      def to_a
        [self.id, self.account_addon.name, self.subscriber.full_name, self.recipient, self.created_at, self.accepted_at, self.declined_at]
      end
    end
  end
end
