module Naas
  module Utilities
    class StatusCodeMapper
      STATUS_MAP = {
        :failure      => (400...500),
        :redirect     => (300...400),
        :success      => (200...300),
        :server_error => (500...600)
      }

      # Returns a utility object to map HTTP
      # status codes to their corresponding
      # ranges
      #
      # @param statuses [Array] Symbols or status codes
      #
      # @return [Naas::StatusCodeMapper] Instance of the object
      def initialize(*statuses)
        @statuses = Array(statuses).flatten
      end

      # Returns a collection of all available codes
      #
      # This merges the STATUS_MAP with specified codes
      #
      # @return [Array] Collection of status codes
      def codes
        all_codes = []
        @statuses.inject(all_codes) do |collection,status|
          if status.is_a?(Symbol)
            collection.concat(STATUS_MAP[status].to_a)
          else
            collection.concat([status.to_i])
          end

          collection
        end

        Set.new(all_codes).to_a
      end

      # Checks to see if the codes includes a specific code
      #
      # @param code [String,Integer] An HTTP code
      #
      # @return [Boolean]
      def includes?(code)
        self.codes.include?(code.to_i)
      end
    end
  end
end
