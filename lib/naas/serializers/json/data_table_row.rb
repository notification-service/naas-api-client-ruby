require File.expand_path('../data_table_row_columns', __FILE__)

module Naas
  module Serializers
    module Json
      class DataTableRow
        def initialize(attributes={})
          @attributes = attributes
        end

        def c_attributes
          @attributes.fetch('c', [])
        end
        alias columns_attributes c_attributes

        def columns
          @columns ||= Naas::Serializers::Json::DataTableRowColumns.new(self.c_attributes)
        end
      end
    end
  end
end
