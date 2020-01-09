module Naas
  module Models
    class Addons
      include Enumerable

      COLUMNS = ['ID', 'Name', 'Description', 'Created At']

      # Return an instance of the addons
      #
      # @param collection [Array]
      #
      # @return [Naas::Models::Addons]
      def initialize(collection)
        @collection = Array(collection)
      end

      # Helper to retrieve the headings collection
      #
      # @return [Array]
      def self.headings
        COLUMNS
      end

      # Returns the class level headings
      #
      # @return [Array]
      def headings
        self.class.headings
      end

      # Helper method to retrieve from the
      # request
      #
      # @param params [Hash]
      #
      # @return [Naas::Models::Addons]
      def self.list(params={})
        request = Naas::Requests::Addons.list(params)

        klass_attributes = []

        request.on(:success) do |resp|
          klass_attributes = resp.data_attributes
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the addons: %s" % [resp.status]) }
        end

        self.new(klass_attributes)
      end

      # Helper method to retrieve from the request
      #
      # @param id [String]
      # @param params [Hash]
      #
      # @return [Naas::Models::Addon]
      def self.retrieve(id, params={})
        request = Naas::Requests::Addons.retrieve(id, params)

        request.on(:success) do |resp|
          return Naas::Models::Addon.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the addon: %s" % [resp.status]) }

          return nil
        end
      end

      # Retrieve the model from the request
      #
      # @param id [String]
      # @param params [Hash]
      #
      # @raises [Naas::Errors::RecordNotFoundError]
      #
      # @return [Naas::Models::Addon]
      def self.retrieve!(id, params={})
        request = Naas::Requests::Addons.retrieve(id, params)

        request.on(:success) do |resp|
          return Naas::Models::Addon.new(resp.data_attributes)
        end

        request.on(404) do
          raise Naas::Errors::RecordNotFoundError.new("Could not find record with id: %s" % [id])
        end
      end

      def each(&block)
        internal_collection.each(&block)
      end

      # Returns the collection serialized as an array
      #
      # @return [Array]
      def to_a
        self.map(&:to_a)
      end

      # Returns an array of options
      #
      # @return [Array]
      def to_options
        self.map(&:to_option)
      end

      private
      def internal_collection
        @collection.map { |record| Naas::Models::Addon.new(record) }
      end
    end
  end
end
