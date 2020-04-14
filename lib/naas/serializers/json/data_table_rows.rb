require File.expand_path('../data_table_row', __FILE__)

module Naas
  module Serializers
    module Json
      class DataTableRows
        include Enumerable

        def initialize(collection)
          @collection = Array(collection)
        end

        def each(&block)
          internal_collection.each(&block)
        end

        private
        def internal_collection
          @collection.map { |record| Naas::Serializers::Json::DataTableRow.new(record) }
        end
      end
    end
  end
end
