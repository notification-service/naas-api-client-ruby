module Naas
  module Models
    class DataTypes
      include Enumerable

      COLUMNS = ['ID', 'Name', 'Description', 'Created At']

      # Return an instance of the data types
      #
      # @param collection [Array]
      #
      # @return [Naas::Models::DataTypes]
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
      # @return [Naas::Models::DataTypes]
      def self.list(params={})
        request = Naas::Requests::DataTypes.list(params)

        klass_attributes = []

        request.on(:success) do |resp|
          klass_attributes = resp.data_attributes
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the data types: %s" % [resp.status]) }
        end

        self.new(klass_attributes)
      end

      # Helper method to retrieve from the request
      #
      # @param id [String]
      # @param params [Hash]
      #
      # @return [Naas::Models::DataType]
      def self.retrieve(id, params={})
        request = Naas::Requests::DataTypes.retrieve(id, params)

        request.on(:success) do |resp|
          return Naas::Models::DataType.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the data type: %s" % [resp.status]) }

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
      # @return [Naas::Models::DataType]
      def self.retrieve!(id, params={})
        request = Naas::Requests::DataTypes.retrieve(id, params)

        request.on(:success) do |resp|
          return Naas::Models::DataType.new(resp.data_attributes)
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
        @collection.map { |record| Naas::Models::DataType.new(record) }
      end
    end
  end
end
