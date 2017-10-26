require "spec_helper"

describe Clickmeetings::Open::Recording do
  describe '::destroy_all' do
    before do
      mock_api :get, 'conferences/1/recordings', open: true
      mock_api :delete, 'conferences/1/recordings', open: true
    end

    subject { described_class.by_conference(conference_id: 1).destroy_all }

    it "responds with array of recordings" do
      expect(subject).to be_an_instance_of(Array)
      expect(subject.first).to be_an_instance_of(described_class)      
    end

    it "response has conference_id" do
      expect(subject.first.conference_id).to eq 1
    end
  end
end
