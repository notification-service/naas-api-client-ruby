require File.expand_path('../data_table_row_column', __FILE__)

module Naas
  module Serializers
    module Json
      class DataTableRowColumns
        include Enumerable

        def initialize(collection)
          @collection = Array(collection)
        end

        def each(&block)
          internal_collection.each(&block)
        end

        def at_index(index_number)
          self.select { |r| r.index.to_i == index_number.to_i }
        end

        private
        def internal_collection
          @collection.each_with_index.map do |record,i|
            record.merge!({ 'index': i })
            Naas::Serializers::Json::DataTableRowColumn.new(record)
          end
        end
      end
    end
  end
end
