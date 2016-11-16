require 'spec_helper'

describe Clickmeetings do
  it 'has a version number' do
    expect(Clickmeetings::VERSION).not_to be nil
  end

  describe '::configure' do
    before do
      described_class.configure do |config|
        config.host = "http://teachbase.ru"
        config.privatelabel_host = "http://go.teachbase.ru"
      end
    end

    subject { described_class.config }

    it "sets config", :aggregate_failures do
      expect(subject.host).to eq "http://teachbase.ru"
      expect(subject.privatelabel_host).to eq "http://go.teachbase.ru"
    end
  end

  describe '::reset' do
    subject { described_class.reset }

    context "config" do
      before(:each) do
        described_class.configure do |config|
          config.host = "http://teachbase.ru"
          config.privatelabel_host = "http://go.teachbase.ru"
        end
      end

      it "resets config" do
        expect { subject }.to change { described_class.config.host }
          .from("http://teachbase.ru").to("https://api.clickmeeting.com/v1")
      end
    end

    context "client" do
      before(:each) do
        described_class::ClientRegistry.client =
          described_class::Client.new(url: "http://teachbase.ru")
      end

      it "resets client" do
        expect { subject }.to change { described_class.client.url }
          .from("http://teachbase.ru").to("https://api.clickmeeting.com/v1")
      end
    end
  end
end
