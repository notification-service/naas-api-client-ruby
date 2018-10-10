module Naas
  module Models
    class CampaignEmailTemplate
      include Comparable

      # Returns an instance of the Campaign Email Template
      #
      # has_many :campaign_email_templates
      #
      # @param attributes [Hash]
      #
      # @return [Naas::Models::CampaignEmailTemplate]
      def initialize(attributes={})
        @attributes = attributes
      end

      #
      # @return [Integer]
      def id
        @attributes['id']
      end

      # Returns the associated campaign id
      #
      # @return [Integer]
      def campaign_id
        @attributes['campaign_id']
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

      # Returns the subject template
      #
      # @return [String]
      def subject
        @attributes['subject']
      end

      # Returns the from email address
      #
      # @return [String]
      def from_email_address
        @attributes['from_email_address']
      end

      # Returns the from name
      #
      # @return [String]
      def from_name
        @attributes['from_name']
      end

      # Returns the HTML body
      #
      # @return [String]
      def html_body
        @attributes['html_body']
      end

      # Returns the plain text body
      #
      # @return [String]
      def text_body
        @attributes['text_body']
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
