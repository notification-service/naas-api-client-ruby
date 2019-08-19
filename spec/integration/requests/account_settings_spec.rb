require 'spec_helper'

RSpec.describe(Naas::Requests::AccountSettings, type: :integration) do
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
    end
  end

  describe ".enable_send_grid" do
    it "enables if not yet set" do
      described_class.disable_send_grid

      expect(described_class.enable_send_grid.status).to eq(200)
    end

    it "returns a 409 if already set" do
      described_class.enable_send_grid

      expect(described_class.enable_send_grid.status).to eq(409)
    end

    it "disables if set" do
      described_class.enable_send_grid

      expect(described_class.disable_send_grid.status).to eq(200)
    end

    it "returns a 200 if already disabled" do
      described_class.disable_send_grid

      expect(described_class.disable_send_grid.status).to eq(200)
    end
  end
end
