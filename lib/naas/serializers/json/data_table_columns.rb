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

        def at_column(column_number)
          self.find { |r| r.index.to_i == column_number.to_i }
        end

        private
        def internal_collection
          @collection.each_with_index.map do |record,i|
            record.merge!({ 'index': i })
            Naas::Serializers::Json::DataTableColumn.new(record)
          end
        end
      end
    end
  end
end
