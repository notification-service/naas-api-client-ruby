module Naas
  module Models
    class Link
      include Comparable

      # Create an instance of the Link domain model
      #
      # @param attributes [Hash]
      #
      # @return [Naas::Models::Link]
      def initialize(attributes={})
        @attributes = attributes
      end

      # Returns the title
      #
      # @return [String]
      def title
        @attributes['title']
      end
      alias name title

      # Returns the href
      #
      # @return [String]
      def href
        @attributes['href']
      end

      # Returns the relationship
      #
      # @return [String]
      def rel
        @attributes['rel']
      end

      # Returns true if this is templated
      #
      # @return [Boolean]
      def templated
        @attributes.fetch('templated', false)
      end
      alias :templated? :templated

      # Returns the fully qualified URL
      #
      # @return [String]
      def url_for(options={})
        if self.templated?
          template = Addressable::Template.new(self.href)
          template = template.expand(options)
          template.to_s
        else
          self.href
        end
      end
    end
  end
end
