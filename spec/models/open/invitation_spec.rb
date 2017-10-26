require "spec_helper"

describe Clickmeetings::Open::Invitation do
  describe '::send_emails' do
    let(:params) { {attendees: [{email: "qwer@qwer.qw"}], role: "listener"} }
    let(:additional_params) { {} }
    subject do
      described_class.by_conference(conference_id: 1).send_emails(params.merge additional_params)
    end

    context 'without additional params' do
      before { mock_api(:post, 'conferences/1/invitation/email/en', open: true) }

      it "returns Invitation", :aggregate_failures do
        expect(subject).to be_an_instance_of(described_class)
        expect(subject.attendees).to be_an_instance_of(Array)
        expect(subject.attendees.first).to be_an_instance_of(Hash)
        expect(subject.attendees.first[:email]).to eq("qwer@qwer.qw")
        expect(subject.role).to eq("listener")
      end
    end

    context 'when params include lang' do
      let(:additional_params) { {lang: :ru} }

      before { mock_api(:post, 'conferences/1/invitation/email/ru', open: true) }

      it "uses lang from params" do
        expect(subject).to be_an_instance_of(described_class)
      end
    end

    context 'when params include conference_id' do
      let(:additional_params) { {conference_id: 2} }

      before { mock_api(:post, 'conferences/2/invitation/email/en', open: true) }

      it "uses conference_id from params" do
        expect(subject).to be_an_instance_of(described_class)
      end
    end
  end
end
