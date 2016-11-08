require "spec_helper"

describe Clickmeetings::PrivateLabel::Profile do
  context '#get' do
    subject { described_class.get }

    before(:each) { mock_api(:get, 'client') }

    specify { expect(subject).to be_an_instance_of described_class }

    it "returns correct values", :aggregate_failures do
      expect(subject.id).to eq 10
      expect(subject.name).to eq "Any Second"
      expect(subject.email).to eq "test@anysecond.com"
      expect(subject.phone).to be_nil
      expect(subject.packages.count).to eq 4
    end
  end
end
