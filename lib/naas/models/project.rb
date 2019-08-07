module Naas
  module Models
    class Project
      include Comparable

      # Returns an instance of the Project
      #
      # @param attributes [Hash]
      #
      # @return [Naas::Models::Project]
      def initialize(attributes={})
        @attributes = attributes

        @errors = []
      end

      def errors
        @errors
      end

      def errors?
        @errors.any?
      end

      def valid?
        !self.errors?
      end

      def save
        record_params = {
          :name        => self.name,
          :description => self.description
        }

        request = Naas::Requests::Projects.create(record_params)

        request.on(:success) do |resp|
          response_body = resp.body
          response_data = response_body.fetch('data', {})

          return self.class.new(response_data)
        end

        request.on(:failure) do |resp|
          response_body = resp.body
          response_data = response_body.fetch('data', {})

          error = Naas::Models::Error.new(response_data)

          error.errors.each { |error_item| @errors.push(error_item.message) }

          self
        end
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

      # Returns the counter cache for campaigns
      #
      # @return [Integer]
      def campaigns_count
        @attributes.fetch('campaigns_count', 0).to_i
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

      # Returns the record as an array
      #
      # @return [Array]
      def to_a
        [self.id, self.name, self.description, self.campaigns_count, self.created_at]
      end
    end
  end
end
