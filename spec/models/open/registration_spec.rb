require "spec_helper"

describe Clickmeetings::Open::Registration do
  describe '::for_session' do
    before { mock_api :get, 'conferences/1/sessions/1/registrations', open: true }

    subject { described_class.by_conference(conference_id: 1).for_session(session_id: 1) }

    it "responds with an array  of registrations" do
      expect(subject).to be_an_instance_of(Array)
      expect(subject.first).to be_an_instance_of(described_class)
    end
  end

  describe '::create' do
    before { mock_api :post, "conferences/1/registration", open: true }

    let(:params) { {registration: {1 => "qwer", 2 => 'qwer', 3 => 'qwer@qwer.qw'}} }
    subject { described_class.by_conference(conference_id: 1).create(params) }

    it "responds with hash" do
      expect(subject).to be_an_instance_of(Hash)
    end
  end
end
