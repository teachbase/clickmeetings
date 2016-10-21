require "spec_helper"

describe Clickmeetings::PrivateLabel::Account do
  specify { expect(described_class.resource_name).to eq "accounts" }

  context "#conferences" do
    let(:object) { described_class.new(id: 1) }
    subject { object.conferences }

    before(:each) { mock_api(:get, "#{described_class.resource_name}/#{object.id}/conferences") }

    it_behaves_like 'conferences list'
  end

  context "#enable" do
    let(:object) { described_class.new(id: 1) }
    subject { object.enable }

    before(:each) { mock_api(:put, "#{described_class.resource_name}/#{object.id}/enable") }

    it "responds with account object with account_status 'active'", :aggregate_failures do
      expect(subject).to be_instance_of described_class
      expect(subject.account_status).to eq 'active'
    end
  end

  context "#disable" do
    let(:object) { described_class.new(id: 1) }
    subject { object.disable }

    before(:each) { mock_api(:put, "#{described_class.resource_name}/#{object.id}/disable") }

    it "responds with account object with account_status 'disabled'", :aggregate_failures do
      expect(subject).to be_instance_of described_class
      expect(subject.account_status).to eq 'disabled'
    end
  end
end
