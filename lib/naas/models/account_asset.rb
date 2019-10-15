module Naas
  module Models
    class AccountAsset

      # Returns an instance of the Account Asset
      #
      # @param attributes [Hash]
      #
      # @return [Naas::Models::AccountAsset]
      def initialize(attributes={})
        @attributes = attributes
      end

      # Returns the id
      #
      # @return [String]
      def id
        @attributes['id']
      end
      alias key_name id

      # Returns the token for the asset
      #
      # @return [String]
      def token
        @attributes['token']
      end

      # Returns the filename specified by the user
      #
      # @return [String]
      def filename
        @attributes['filename']
      end

      # Returns the filename generated by the system
      #
      # @return [String]
      def system_filename
        @attributes['system_filename']
      end

      # Returns the content type
      #
      # @return [String]
      def content_type
        @attributes['content_type']
      end

      # Returns the mime type object
      #
      # @return [MIME::Type]
      def mime_type
        MIME::Types[self.content_type].last
      end

      # Returns true if there is a mime type
      #
      # @return [Boolean]
      def mime_type?
        !self.mime_type.nil?
      end

      # Returns the byte size
      #
      # @return [Integer]
      def byte_size
        @attributes['byte_size'].to_i
      end

      # Returns the checksum
      #
      # @return [String]
      def checksum
        @attributes['checksum']
      end

      # Returns the template URI
      #
      # @return [URI]
      def template_file_uri
        rel   = Naas::Client.rel_for('rels/account-asset-file')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(token: self.token, system_filename: self.system_filename)

        URI(url)
      end

      # Returns true if there is a template file uri
      #
      # @return [Boolean]
      def template_file_uri?
        !self.template_file_uri.nil?
      end

      # Returns the file URI
      #
      # @return [URI]
      def link_file_uri
        link = self.links.find_by_rel('account-asset-file')

        link_uri = nil

        if !link.nil?
          link_uri = URI(link.href)
        end

        link_uri
      end

      # Returns true if there is a file URI
      #
      # @return [Boolean]
      def link_file_uri?
        !self.link_file_uri.nil?
      end

      # Resolve the file URI from local links
      # or the URI template in the directory
      #
      # @return [URI]
      def file_uri
        if self.link_file_uri?
          self.link_file_uri
        elsif self.template_file_uri?
          self.template_file_uri
        else
          nil
        end
      end

      # Returns true if there is a file uri
      #
      # @return [Boolean]
      def file_uri?
        !self.file_uri.nil?
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
