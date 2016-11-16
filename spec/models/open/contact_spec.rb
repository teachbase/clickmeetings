require "spec_helper"

describe Clickmeetings::Open::Contact do
  describe '::create' do
    before { mock_api :post, 'contacts', open: true }

    let(:params) { {email: "q@q.qq", firstname: 'q', lastname: 'Q'} }
    subject { described_class.create(params) }

    it "responds with a Contact object", :aggregate_failures do
      expect(subject).to be_an_instance_of(described_class)
      expect(subject.email).to eq('q@q.qq')
      expect(subject.firstname).to eq('q')
      expect(subject.lastname).to eq('Q')
    end
  end
end
