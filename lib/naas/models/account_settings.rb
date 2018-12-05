module Naas
  module Models
    class AccountSettings
      # Helper method to retrieve from the request
      #
      # @return [Naas::Models::AccountSetting]
      def self.retrieve
        request = Naas::Requests::AccountSettings.retrieve

        klass_attributes = {}

        request.on(:success) do |resp|
          response_body = resp.body
          response_data = response_body.fetch('data', {})

          klass_attributes = response_data

          return Naas::Models::AccountSetting.new(klass_attributes)
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.info { ("Failure retrieving the subscriber email address: %s" % [resp.status]) }

          return nil
        end
      end
    end
  end
end
