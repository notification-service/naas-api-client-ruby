module Naas
  module Models
    class Pagination

      # Returns an instance of the Pagination domain model
      #
      # @param attributes [Hash]
      #
      # @return [Naas::Models::Pagination]
      def initialize(attributes={})
        @attributes = attributes
      end

      # Returns the curren tpage
      #
      # @return [Integer]
      def page
        @attributes['page'].to_i
      end
      alias :current_page :page

      # Returns the number of items per page
      #
      # @return [Integer]
      def per_page
        @attributes['per_page'].to_i
      end

      # Returns the total number of entries
      #
      # @return [Integer]
      def total
        @attributes['total'].to_i
      end
      alias :total_entries :total

      # Returns the maximum per page
      #
      # @return [Integer]
      def maximum_per_page
        @attributes['maximum_per_page'].to_i
      end

      # Returns the total number of pages
      #
      # @return [Integer]
      def total_pages
        (self.total.to_f / self.per_page.to_f).ceil.to_i
      end
    end
  end
end
