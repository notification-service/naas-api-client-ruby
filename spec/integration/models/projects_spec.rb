require 'spec_helper'

RSpec.describe(Naas::Models::Projects) do
  let(:params) do
    {
      :name        => 'My First Project',
      :description => 'My first description'
    }
  end

  describe ".create" do
    context "with validations" do
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
