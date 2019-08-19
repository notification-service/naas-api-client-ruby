require 'spec_helper'

RSpec.describe(Naas::Models::Projects, type: :integration) do
  let(:params) do
    {
      :name        => 'My First Project',
      :description => 'My first description'
    }
  end

  describe ".create" do
    context "with validations" do
      context "arguments" do
        it "gracefully handles nil" do
          expect { described_class.create(nil) }.to raise_error(Naas::Errors::InvalidArgumentError)
        end

        it "gracefully handles number" do
          expect { described_class.create(22) }.to raise_error(Naas::Errors::InvalidArgumentError)
        end

        it "gracefully handles string" do
          expect { described_class.create('invalid') }.to raise_error(Naas::Errors::InvalidArgumentError)
        end
      end

      it "ensures there is a name" do
        params[:name] = nil

        expect { described_class.create(params) }.to raise_error(Naas::Errors::InvalidRequestError)
      end

      it "ensures the #id is valid" do
        params[:id] = 'invalid id'

        expect { described_class.create(params) }.to raise_error(Naas::Errors::InvalidRequestError)
      end
    end

    context "with valid data" do
      it "creates a new record" do
        record = described_class.create(params)

        expect(record.name).to eq('My First Project')
      end
    end
  end
end
