require 'spec_helper'

RSpec.describe(Naas::Requests::Accounts, type: :integration) do
  let(:params) do
    {
      :name => 'My First Account'
    }
  end

  describe ".retrieve" do
    it "returns a 200 OK" do
      expect(described_class.retrieve.status).to eq(200)
    end
  end

  describe ".update" do
    it "permits updating the name" do
      expect(described_class.update(name: 'New Name').status).to eq(200)
    end

    context "with validations" do
      context "arguments" do
        context "params" do
          it "raises an exception if nil is provided" do
            expect { described_class.update(nil) }.to raise_error(Naas::Errors::InvalidArgumentError)
          end

          it "raises an exception if a number is provided" do
            expect { described_class.update(22) }.to raise_error(Naas::Errors::InvalidArgumentError)
          end

          it "raises an exception if a string is provided" do
            expect { described_class.update('invalid') }.to raise_error(Naas::Errors::InvalidArgumentError)
          end
        end
      end

      it "ensures there is a name" do
        params[:name] = nil

        expect(described_class.update(params).status).to eq(409)
      end
    end
  end
end
