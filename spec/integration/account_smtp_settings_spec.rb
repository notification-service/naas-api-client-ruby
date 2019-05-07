require 'spec_helper'

RSpec.describe(Naas::Models::AccountSmtpSettings) do
  before(:all) do
    Naas::Client.configure do |config|
      config.api_host       = ENV.fetch('NAAS_API_HOST_TEST')
      config.access_token   = ENV.fetch('NAAS_ACCESS_TOKEN_TEST')
      config.logger         = Logger.new(File.expand_path('../../../log/naas_test.log', __FILE__))
      config.request_logger = Logger.new(File.expand_path('../../../log/naas_test_requests.log', __FILE__))
    end

    WebMock.disable!
  end

  let(:params) do
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

  describe ".create" do
    context "with validations" do
      it "ensures there is a #name" do
        params[:name] = nil

        expect { described_class.create(params) }.to raise_error(Naas::Errors::InvalidRequestError)
      end

      it "ensures there is a #address" do
        params[:address] = nil

        expect { described_class.create(params) }.to raise_error(Naas::Errors::InvalidRequestError)
      end

      it "ensures there is a valid #address" do
        params[:address] = 'fake.example.com'

        expect { described_class.create(params) }.to raise_error(Naas::Errors::InvalidRequestError)
      end


      it "ensures there is a #user_name" do
        params[:user_name] = nil

        expect { described_class.create(params) }.to raise_error(Naas::Errors::InvalidRequestError)
      end

      describe "password" do
        it "ensures there is a #password" do
          params[:password] = nil

          expect { described_class.create(params) }.to raise_error(Naas::Errors::InvalidRequestError)
        end

        it "ensures there is a #password_confirmation" do
          params[:password_confirmation] = nil

          expect { described_class.create(params) }.to raise_error(Naas::Errors::InvalidRequestError)
        end

        it "ensures the passwords match" do
          params[:password_confirmation] = 'abcd1234'
          params[:password_confirmation] = 'abcd1233'

          expect { described_class.create(params) }.to raise_error(Naas::Errors::InvalidRequestError)
        end
      end

      it "ensures the #id is valid" do
        params[:id] = 'invalid id'

        expect { described_class.create(params) }.to raise_error(Naas::Errors::InvalidRequestError)
      end
    end

    context "with valid data" do
      it "creates a new record" do
        record = described_class.create(params)

        expect(record.name).to eq('My SMTP Provider')
      end
    end
  end
end
