require 'spec_helper'

RSpec.describe(Naas::Models::Campaigns) do
  let(:project_id) do
    'campaign-testing'
  end

  let(:project) do
    begin
      Naas::Models::Projects.retrieve!(project_id)
    rescue Naas::Errors::RecordNotFoundError
      Naas::Models::Projects.create(id: project_id, name: 'Campaign Testing', description: 'testing the campaign')
    end
  end

  let(:params) do
    {
      :name        => 'My First Campaign',
      :description => 'My first campaign description'
    }
  end

  describe ".create_by_project_id" do
    context "with validations" do
      it "ensures there is a name" do
        params[:name] = nil

        expect { described_class.create_by_project_id(project.id, params) }.to raise_error(Naas::Errors::InvalidRequestError)
      end

      it "ensures the #id is valid" do
        params[:id] = 'invalid id'

        expect { described_class.create_by_project_id(project.id, params) }.to raise_error(Naas::Errors::InvalidRequestError)
      end
    end

    context "with valid data" do
      it "creates a new record" do
        record = described_class.create_by_project_id(project.id, params)

        expect(record.name).to eq('My First Campaign')
      end
    end
  end
end
