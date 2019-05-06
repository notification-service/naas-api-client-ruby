require 'spec_helper'

RSpec.describe(Naas::Models::CampaignEmailTemplates) do
  before(:all) do
    Naas::Client.configure do |config|
      config.api_host       = ENV.fetch('NAAS_API_HOST_TEST')
      config.access_token   = ENV.fetch('NAAS_ACCESS_TOKEN_TEST')
      config.logger         = Logger.new(File.expand_path('../../../log/naas_test.log', __FILE__))
      config.request_logger = Logger.new(File.expand_path('../../../log/naas_test_requests.log', __FILE__))
    end

    WebMock.disable!
  end

  let(:project_id) do
    'campaign-testing'
  end

  let(:campaign_id) do
    'campaign-template-testing'
  end

  let(:project) do
    begin
      Naas::Models::Projects.retrieve!(project_id)
    rescue Naas::Errors::RecordNotFoundError
      Naas::Models::Projects.create(id: project_id, name: 'Campaign Testing', description: 'testing the campaign')
    end
  end

  let(:campaign) do
    begin
      Naas::Models::Campaigns.retrieve_by_project_id!(project_id, campaign_id)
    rescue Naas::Errors::RecordNotFoundError
      Naas::Models::Campaigns.create_by_project_id(project_id, id: campaign_id, name: 'My First Campaign', description: 'Testing the campaign email template')
    end
  end

  let(:params) do
    {
      :name               => 'My First Campaign Template',
      :subject            => 'Campaign Subject',
      :from_email_address => 'lester@tester.com',
      :from_name          => 'Lester Tester',
      :text_body          => "Here is the text body",
      :html_body          => "Here is the HTML body",
      :description        => 'My first campaign email template description'
    }
  end

  describe ".create_by_project_id_and_campaign_id" do
    context "with validations" do
      it "ensures there is a #subject" do
        params[:subject] = nil

        expect { described_class.create_by_project_id_and_campaign_id(project.id, campaign.id, params) }.to raise_error(Naas::Errors::InvalidRequestError)
      end

      it "ensures there is a #from_email_address" do
        params[:from_email_address] = nil

        expect { described_class.create_by_project_id_and_campaign_id(project.id, campaign.id, params) }.to raise_error(Naas::Errors::InvalidRequestError)
      end

      it "ensures there is a #from_name" do
        params[:from_name] = nil

        expect { described_class.create_by_project_id_and_campaign_id(project.id, campaign.id, params) }.to raise_error(Naas::Errors::InvalidRequestError)
      end

      it "ensures there is at least one body" do
        params[:html_body] = nil
        params[:text_body] = nil

        expect { described_class.create_by_project_id_and_campaign_id(project.id, campaign.id, params) }.to raise_error(Naas::Errors::InvalidRequestError)
      end

      it "ensures the #id is valid" do
        params[:id] = 'invalid id'

        expect { described_class.create_by_project_id_and_campaign_id(project.id, campaign.id, params) }.to raise_error(Naas::Errors::InvalidRequestError)
      end
    end

    context "with valid data" do
      it "creates a new record" do
        record = described_class.create_by_project_id_and_campaign_id(project.id, campaign.id, params)

        expect(record.name).to eq('My First Campaign Template')
      end
    end
  end
end
