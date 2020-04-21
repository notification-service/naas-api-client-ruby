module Naas
  module Serializers
    module Json
      class DataTableRowColumn

        def initialize(attributes={})
          @attributes = attributes
        end

        def index
          @attributes[:index].to_i
        end

        def v
          @attributes['v']
        end
        alias value v

        def f
          @attributes['f']
        end
        alias formatted_value f
      end
    end
  end
end
