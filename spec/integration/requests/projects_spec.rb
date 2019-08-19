require 'spec_helper'

RSpec.describe(Naas::Requests::Projects, type: :integration) do
  let(:params) do
    {
      :name        => 'My First Project',
      :description => 'My first description'
    }
  end

  describe ".list" do
    it "returns a 200 status code" do
      expect(described_class.list.status).to eq(200)
    end

    it "returns a collection of data" do
      expect(described_class.list.data_attributes).to be_a(Array)
    end
  end

  describe ".retrieve" do
    before(:all) do
      record_params = {
        :id          => 'test-retrieve',
        :name        => 'My First Project',
        :description => 'My first description'
      }

      described_class.create(record_params)
    end

    it "returns a 200 OK" do
      expect(described_class.retrieve('test-retrieve').status).to eq(200)
    end

    it "returns a 404 not found for non existent record" do
      expect(described_class.retrieve('notfound').status).to eq(404)
    end

    it "returns a 404 not found for nil" do
      expect { described_class.retrieve(nil) }.to raise_error(Naas::Errors::InvalidArgumentError)
    end
  end

  describe ".update" do
    before(:all) do
      record_params = {
        :id          => 'test-retrieve',
        :name        => 'My First Project',
        :description => 'My first description'
      }

      described_class.create(record_params)
    end

    it "permits updating the name" do
      expect(described_class.update('test-retrieve', name: 'New Name').status).to eq(200)
    end

    context "with validations" do
      context "arguments" do
        context "id" do
          it "raises an exception if nil is presented" do
            expect { described_class.update(nil, params) }.to raise_error(Naas::Errors::InvalidArgumentError)
          end
        end

        context "params" do
          it "raises an exception if nil is provided" do
            expect { described_class.update('test-retrieve', nil) }.to raise_error(Naas::Errors::InvalidArgumentError)
          end

          it "raises an exception if a number is provided" do
            expect { described_class.update('test-retrieve', 22) }.to raise_error(Naas::Errors::InvalidArgumentError)
          end

          it "raises an exception if a string is provided" do
            expect { described_class.update('test-retrieve', 'invalid') }.to raise_error(Naas::Errors::InvalidArgumentError)
          end
        end
      end

      it "ensures there is a name" do
        params[:name] = nil

        expect(described_class.update('test-retrieve', params).status).to eq(409)
      end

      it "ensures the #id is valid" do
        params[:id] = 'invalid id'

        expect(described_class.update('test-retrieve', params).status).to eq(409)
      end
    end
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

        expect(described_class.create(params).status).to eq(409)
      end

      it "ensures the #id is valid" do
        params[:id] = 'invalid id'

        expect(described_class.create(params).status).to eq(409)
      end
    end

    context "with valid data" do
      it "creates a new record" do
        record = described_class.create(params)

        expect(record.status).to eq(201)
      end
    end
  end
end
