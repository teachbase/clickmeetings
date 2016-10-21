require "spec_helper"

describe Clickmeetings::Client do
  let(:client) do
    described_class.new(url: Clickmeetings.config.privatelabel_host,
                        api_key: Clickmeetings.config.privatelabel_api_key)
  end

  it "should create client", :aggregate_failures do
    expect(subject.api_key).to eq Clickmeetings.config.api_key
    expect(subject.url).to eq Clickmeetings.config.host
  end

  context "when response success" do
    before(:each) { mock_api(:get, "client") }

    it "gets client's info" do
      res = client.get "client"
      expect(res).to eq JSON.parse(File.read("./spec/fixtures/get_client.json"))
    end
  end

  {
    400 => Clickmeetings::BadRequestError,
    401 => Clickmeetings::Unauthorized,
    403 => Clickmeetings::Forbidden,
    404 => Clickmeetings::NotFound,
    422 => Clickmeetings::UnprocessedEntity,
    500 => Clickmeetings::InternalServerError
  }.each do |status, error_class|
    context "when response status is #{status}" do
      before(:each) { mock_api(:get, "client", status) }
      subject { client.get "client" }
      specify { expect { subject }.to raise_error error_class }
    end
  end
end
