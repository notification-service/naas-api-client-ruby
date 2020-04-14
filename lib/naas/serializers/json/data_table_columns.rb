require File.expand_path('../data_table_column', __FILE__)

module Naas
  module Serializers
    module Json
      class DataTableColumns
        include Enumerable

        def initialize(collection)
          @collection = Array(collection)
        end

        def each(&block)
          internal_collection.each(&block)
        end

        private
        def internal_collection
          @collection.map { |record| Naas::Serializers::Json::DataTableColumn.new(record) }
        end
      end
    end
  end
end
