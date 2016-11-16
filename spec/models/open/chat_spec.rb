require "spec_helper"

describe Clickmeetings::Open::Chat do
  describe '::find' do
    before do
      stub_request(:get, 'https://api.clickmeeting.com/v1/chats/1')
        .to_return(
          status: 200,
          headers: {
           "content-type"=>"application/zip",
           "transfer-encoding"=>"chunked",
           "connection"=>"close",
           "content-disposition"=>"attachment; filename=chat_history_5342110_20161117_161522.zip"
          },
          body: File.read('spec/fixtures/get_chats_1.zip')
        )
    end

    subject { described_class.find(1) }

    it "responds with file content" do
      expect(subject).to eq(File.read('spec/fixtures/get_chats_1.zip'))
    end
  end
end
