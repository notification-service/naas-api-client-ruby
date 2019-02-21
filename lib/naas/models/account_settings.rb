module Naas
  module Models
    class AccountSettings
      # Helper method to retrieve from the request
      #
      # @return [Naas::Models::AccountSetting]
      def self.retrieve
        request = Naas::Requests::AccountSettings.retrieve

        request.on(:success) do |resp|
          return Naas::Models::AccountSetting.new(resp.data_attributes)
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the account settings: %s" % [resp.status]) }

          return nil
        end
      end
    end
  end
end
