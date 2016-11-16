require "spec_helper"

describe Clickmeetings::Open::Session do
  describe '::find' do
    before { mock_api :get, 'conferences/1/sessions/1', open: true }

    subject { described_class.by_conference(conference_id: 1).find(1) }

    it "sets an id" do
      expect(subject.id).to eq 1
    end
  end

  describe '#attendees' do
    before { mock_api :get, 'conferences/1/sessions/1/attendees', open: true }

    subject { described_class.by_conference(conference_id: 1).new(id: 1).attendees }

    it "responds with hashes", :aggregate_failures do
      expect(subject).to be_an_instance_of(Array)
      expect(subject.first).to be_an_instance_of(Hash)
    end
  end

  describe '#generate_pdf' do
    before { mock_api :get, 'conferences/1/sessions/1/generate-pdf/en', open: true }

    subject { described_class.by_conference(conference_id: 1).new(id: 1).generate_pdf }

    it "responds with a hash", :aggregate_failures do
      expect(subject).to be_an_instance_of(Hash)
      expect(subject.keys).to include("status")
      expect(subject.keys).to include("progress")
    end
  end

  describe '#get_report' do
    context 'when \'in progress\'' do
      before { mock_api :get, 'conferences/1/sessions/1/generate-pdf/ru', open: true }

      subject { described_class.by_conference(conference_id: 1).new(id: 1).get_report :ru }

      it "responds with nil" do
        expect(subject).to be_nil
      end
    end

    context 'when \'finished\'' do
      before { mock_api :get, 'conferences/1/sessions/1/generate-pdf/pl', open: true }

      subject { described_class.by_conference(conference_id: 1).new(id: 1).get_report :pl }

      it 'responds with url' do
        expect(subject).to eq("http://api.anysecond.com/panel/pdf/ru/5342110/VAqcdc")
      end
    end
  end

  describe 'registrations' do
    before { mock_api :get, 'conferences/1/sessions/1/registrations', open: true }

    subject { described_class.by_conference(conference_id: 1).new(id: 1).registrations }

    it 'responds with an array of Registration objects' do
      expect(subject).to be_an_instance_of(Array)
      expect(subject.first).to be_an_instance_of(Clickmeetings::Open::Registration)
    end

    it 'respond contains conference_id' do
      expect(subject.first.conference_id).to eq(1)
    end
  end
end
