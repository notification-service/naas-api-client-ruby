module Naas
  module Models
    class AccountSetting
      # Returns an instance of the account setting
      #
      # @param attributes [Hash]
      #
      # @return [Naas::Models::AccountSetting]
      def initialize(attributes={})
        @attributes = attributes
      end

      # Returns the send grid webhook token
      #
      # @return [String,NilClass]
      def send_grid_webhook_token
        @attributes['send_grid_webhook_token']
      end

      # Returns true if there is a send grid
      # webhook token
      #
      # @return [Boolean]
      def send_grid_webhook_token?
        !self.send_grid_webhook_token.nil? && !self.send_grid_webhook_token.blank?
      end

      # Returns the send grid webhook url
      #
      # @return [String,NilClass]
      def send_grid_webhook_url
        @attributes['send_grid_webhook_url']
      end

      # Returns true if there is a send grid
      # webhook url
      #
      # @return [Boolean]
      def send_grid_webhook_url?
        !self.send_grid_webhook_url.nil? && !self.send_grid_webhook_url.blank?
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
    end
  end
end
