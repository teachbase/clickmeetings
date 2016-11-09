require 'spec_helper'

describe Clickmeetings::Model do
  context "class methods" do
    context ".find" do
      subject { described_class.find(1) }
      before(:each) { mock_api(:get, "#{described_class.resource_name}/1", open: true) }

      it "returns Model object", :aggregate_failures do
        expect(subject).to be_instance_of described_class
        expect(subject.id).to eq 1
      end
    end

    context ".all" do
      subject { described_class.all }
      before(:each) { mock_api(:get, described_class.resource_name, open: true) }

      it "returns array of model objects", :aggregate_failures do
        expect(subject).to be_instance_of Array
        expect(subject.first).to be_instance_of described_class
        expect(subject.first.id).to eq 514136
      end
    end

    context ".resource_name" do
      subject { described_class.resource_name }

      specify { expect(subject).to eq "models" }
    end

    context ".set_resource_name" do
      subject { described_class.set_resource_name "resources" }
      after { described_class.set_resource_name "models" }

      specify do
        expect { subject }.to change { described_class.resource_name }
          .from("models").to("resources")
      end
    end

    context ".create" do
      subject { described_class.create }
      before(:each) { mock_api(:post, described_class.resource_name, open: true) }

      it "returns Model objects" do
        expect(subject).to be_instance_of described_class
        expect(subject.id).to eq 1
      end
    end
  end

  context "instance methods" do
    context "#update" do
      let(:params) { {id: 2} }
      let(:object) { described_class.new(id: 1) }
      subject { object.update(params) }

      before(:each) { mock_api(:put, "#{described_class.resource_name}/#{object.id}", open: true) }

      it "returns updated Mode object" do
        expect(subject).to be_instance_of described_class
        expect(subject.id).to eq 2
      end
    end

    context "#destroy" do
      let(:object) { described_class.new(id: 1) }
      subject { object.destroy }

      before(:each) { mock_api(:delete, "#{described_class.resource_name}/#{object.id}", open: true) }

      it "returns destroyed object" do
        expect(subject).to be_instance_of described_class
        expect(subject.id).to eq 1
      end
    end
  end
end
