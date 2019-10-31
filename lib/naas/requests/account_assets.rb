require 'mime/types'
require 'mimemagic'
require 'base64'

module Naas
  module Requests
    class AccountAssets
      # Retrieve the list of account assets
      #
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.list(params={})
        rel   = Naas::Client.rel_for('rels/account-assets')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params)

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Retrieve the instance of an account asset
      #
      # @param id [Integer]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.retrieve(id, params={})
        rel   = Naas::Client.rel_for('rels/account-asset')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(params.merge!(id: id))

        request = Naas::Client.connection.get do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
        end

        Naas::Response.new(request)
      end

      # Create an instance of an account asset
      #
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.create(params={})
        rel   = Naas::Client.rel_for('rels/account-assets')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for

        request_body = {
          :asset => params
        }

        request = Naas::Client.connection.post do |req|
          req.url(url)
          req.headers['Accept'] = 'application/vnd.naas.json; version=1'
          req.body = MultiJson.dump(request_body)
        end

        Naas::Response.new(request)
      end

      # Create a record from file contents
      #
      # @param file_content [String]
      # @param mime_type [String]
      # @param params [Hash]
      #
      # @raises [Naas::Errors::InvalidFileError]
      #
      # @return [Naas::Response]
      def self.create_from_file_content(file_content, mime_type, params={})
        begin
          file_object = StringIO.new(file_content)
        rescue TypeError
          raise Naas::Errors::InvalidFileError.new("File content is not readable")
        end

        self.create_from_file(file_object, mime_type, params)
      end

      # Create a record from a specified file
      #
      # @param file [File,IO]
      # @param mime_type [String]
      # @param params [Hash]
      #
      # @raises [Naas::Errors::InvalidFileError]
      #
      # @return [Naas::Response]
      def self.create_from_file(file, mime_type, params={})
        raise Naas::Errors::InvalidFileError.new("Can't read file") if !file.respond_to?(:read)

        file.rewind

        file_bytes       = file.read
        encoded_bytes    = Base64.strict_encode64(file_bytes)
        detected_type    = MimeMagic.by_magic(file_bytes)
        content_type     = ((detected_type && detected_type.type) || mime_type)
        system_mime_type = MIME::Types[content_type].last

        raise Naas::Errors::InvalidMimeTypeError.new("Invalid mime type of %s" % [mime_type]) if system_mime_type.nil?

        content_data_url = "data:%s;base64,%s" % [system_mime_type.to_s, encoded_bytes]

        params.merge!(content_data_url: content_data_url)

        self.create(params)
      end

      # Create a record from a specified file path
      #
      # @param file_path [String,Pathname]
      # @param mime_type [String]
      # @param params [Hash]
      #
      # @raises [Naas::Errors::InvalidFileError]
      # @raises [Naas::Errors::InvalidFilePathError]
      #
      # @return [Naas::Response]
      def self.create_from_file_path(file_path, mime_type, params={})
        raise Naas::Errors::InvalidFilePathError.new("Must provide a valid file path") if !File.file?(file_path)

        file = File.open(file_path)

        self.create_from_file(file, mime_type, params)
      end

      # Retrieve the file content for an account asset
      #
      # @param token [String]
      # @param system_filename [String]
      # @param params [Hash]
      #
      # @return [Naas::Response]
      def self.retrieve_file(token, system_filename, params={})
        rel   = Naas::Client.rel_for('rels/account-asset-file')
        route = Naas::Client.routes.find_by_rel(rel)
        url   = route.url_for(token: token, system_filename: system_filename)

        request = Naas::Client.connection.get do |req|
          req.url(url)
        end

        Naas::Response.new(request)
      end
    end
  end
end
