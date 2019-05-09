require 'spec_helper'

RSpec.describe(Naas::Models::EmailNotificationBasic) do
  let(:project_id) do
    'campaign-testing'
  end

  let(:campaign_id) do
    'campaign-template-testing'
  end

  let(:campaign_email_template_id) do
    'campaign-email-template-testing'
  end

  let(:account_smtp_setting_id) do
    'campaign-account-smtp-setting-testing'
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

  let(:campaign_email_template_params) do
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

  let(:campaign_email_template) do
    begin
      Naas::Models::CampaignEmailTemplates.retrieve_by_project_id_and_campaign_id!(project_id, campaign_id, campaign_email_template_id)
    rescue Naas::Errors::RecordNotFoundError
      Naas::Models::CampaignEmailTemplates.create_by_project_id_and_campaign_id(project_id, campaign_id, campaign_email_template_params.merge!(id: campaign_email_template_id))
    end
  end

  let(:account_smtp_setting_params) do
    {
      :name                      => 'My SMTP Provider',
      :description               => 'My SMTP description',
      :address                   => ENV['TEST_SMTP_HOST'],
      :domain                    => 'app.example.com',
      :password                  => ENV['TEST_SMTP_PASSWORD'],
      :password_confirmation     => ENV['TEST_SMTP_PASSWORD'],
      :port                      => 587,
      :user_name                 => ENV['TEST_SMTP_USERNAME'],
      :authentication_type_value => 'plain',
      :is_primary                => true
    }
  end

  let(:account_smtp_setting) do
    begin
      Naas::Models::AccountSmtpSettings.retrieve!(account_smtp_setting_id)
    rescue Naas::Errors::RecordNotFoundError
      Naas::Models::AccountSmtpSettings.create(account_smtp_setting_params.merge!(id: account_smtp_setting_id))
    end
  end

  let(:email_address) do
    ("lester+%s@test.com" % [SecureRandom.hex(12)])
  end

  let(:params) do
    {
      :project_id                 => project.id,
      :campaign_id                => campaign.id,
      :campaign_email_template_id => campaign_email_template.id,
      :email_address              => email_address,
      :options => {
        :account_smtp_setting_id    => account_smtp_setting.id,
      }
    }
  end

  describe ".create" do
    context "with validations" do
      it "ensures there is a #project_id" do
        params[:project_id] = nil

        expect { described_class.create(params) }.to raise_error(Naas::Errors::InvalidRequestError)
      end
    end

    context "with valid data" do
      it "creates a new record" do
        record = described_class.create(params)

        expect(record.to_email_address).to eq(email_address)
      end
    end
  end
end
