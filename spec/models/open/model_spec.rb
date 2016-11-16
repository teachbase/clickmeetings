require "spec_helper"

describe Clickmeetings::Open::Model do
  describe '#default_headers' do
    subject { described_class.default_headers["X-Api-Key"] }

    it "uses default account_api_key" do
      expect(subject).to eq Clickmeetings.config.api_key
    end
  end

  describe '::with_account' do
    context 'when use without block' do
      before { described_class.with_account account_api_key: "some_else_key" }
      after(:all) { described_class.with_account account_api_key: nil }

      subject { described_class.default_headers["X-Api-Key"] }

      it "uses specified key" do
        expect(subject).to eq "some_else_key"
      end
    end

    context 'when use with block' do
      subject do
        subj = described_class.with_account account_api_key: "anykey" do
          described_class.default_headers
        end
        subj["X-Api-Key"]
      end

      it "uses specified key in block" do
        expect(subject).to eq "anykey"
      end

      it "uses default key out of block" do
        expect(described_class.default_headers["X-Api-Key"]).to eq Clickmeetings.config.api_key
      end
    end
  end

  describe '::ping' do
    before do
      stub_request(:get, "#{Clickmeetings.config.host}/ping")
        .to_return(status: 200, body: "{\"ping\":\"pong\"}")
    end

    subject { described_class.ping }

    it "responds with {\"ping\":\"pong\"}", :aggregate_failures do
      expect(subject).to be_instance_of Hash
      expect(subject).to eq({"ping" => "pong"})
    end
  end
end
