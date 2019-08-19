module Naas
  module Models
    class ProjectSubscriberProfile
      def initialize(attributes={})
        @attributes = attributes

        @project_id            = @attributes.delete('project_id')
        @project_subscriber_id = @attributes.delete('project_subscriber_id')

        @attributes.each do |key,value|
          instance_variable_set("@#{key}", value)
          instance_variable_get("@#{key}")

          self.class.send(:define_method, key) do
            value
          end
        end
      end

      # Retrieve by the project and project subscriber id
      #
      # @param project_id [String]
      # @param project_subscriber_id [String]
      # @param params [Hash]
      #
      # @return [Naas::Models::ProjectSubscriberProfile]
      def self.retrieve_by_project_id_and_project_subscriber_id(project_id, project_subscriber_id, params={})
        request = Naas::Requests::ProjectSubscriberProfiles.retrieve_by_project_id_and_project_subscriber_id(project_id, project_subscriber_id, params)

        request.on(:success) do |resp|
          data = resp.data_attributes
          data.merge!('project_id' => project_id)
          data.merge!('project_subscriber_id' => project_subscriber_id)

          return Naas::Models::ProjectSubscriberProfile.new(data)
        end

        request.on(:failure) do |resp|
          Naas::Client.configuration.logger.error { ("Failure retrieving the project subscriber profile: %s" % [resp.status]) }

          return nil
        end
      end

      # Retrieve by the project and project subscriber id
      #
      # @param project_id [String]
      # @param project_subscriber_id [String]
      # @param params [Hash]
      #
      # @return [Naas::Models::ProjectSubscriberProfile]
      def self.update_by_project_id_and_project_subscriber_id(project_id, project_subscriber_id, params={})
        request = Naas::Requests::ProjectSubscriberProfiles.update_by_project_id_and_project_subscriber_id(project_id, project_subscriber_id, params)

        request.on(:succes) do |resp|
          data = resp.data_attributes
          data.merge!('project_id' => project_id)
          data.merge!('project_subscriber_id' => project_subscsriber_id)

          return Naas::Models::ProjectSubscriberProfiler.new(data)
        end

        request.on(:failure) do |resp|
          error           = Naas::Models::Error.new(resp.data_attributes)
          failure_message = "Failure updating the record: %s" % [error.full_messages.inspect]

          Naas::Client.configuration.logger.error { failure_message }

          raise Naas::Errors::InvalidRequestError.new(failure_message)
        end
      end

      # Returns the associated project id
      #
      # @return [String]
      def project_id
        @project_id
      end

      # Returns any project attributes
      #
      # @return [Hash]
      def project_attributes
        @attributes.fetch('project', {})
      end

      # Returns true if there are project attributes
      #
      # @return [Boolean]
      def project_attributes?
        !self.project_attributes.empty?
      end

      # Returns an instance of the project
      #
      # @return [Naas::Models::Project]
      def project
        return @project if @project

        @project = if self.project_attributes?
                     Naas::Models::Project.new(self.project_attributes)
                   else
                     Naas::Models::Projects.retrieve(self.project_id)
                   end

        @project
      end

      # Returns the associated project subscriber id
      #
      # @return [String]
      def project_subscriber_id
        @project_subscriber_id
      end

      # Returns any project subscsriber attributes
      #
      # @return [Hash]
      def project_subscriber_attributes
        @attributes.fetch('project_subscriber', {})
      end

      # Reeturns true if there are project subscriber attributes
      #
      # @return [Boolean]
      def project_subscriber_attributes?
        !self.project_subscriber_attributes.empty?
      end

      # Returns the associated project subscriber
      #
      # @return [Naas::Models::ProjectSubscriber]
      def project_subscriber
        return @project_subscriber if @project_subscriber

        @project_subscriber = if self.project_subscriber_attributes?
                                Naas::Models::ProjectSubscriber.new(self.project_subscriber_attributes)
                              else
                                Naas::Models::ProjectSubscribers.retrieve_by_project_id(self.project_id, self.project_subscriber_id)
                              end

        @project_subscriber
      end
    end
  end
end
