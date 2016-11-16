require "spec_helper"

describe Clickmeetings::Client do
  let(:client) do
    described_class.new(url: Clickmeetings.config.privatelabel_host)
  end

  it "should create client" do
    expect(subject.url).to eq Clickmeetings.config.host
  end

  context "when response success" do
    before(:each) { mock_api(:get, "client") }

    it "gets client's info" do
      res = client.get "client"
      expect(res).to eq JSON.parse(File.read("./spec/fixtures/get_client.json"))
    end
  end

  context "with header authorization" do
    before do
      stub_request(:get, "#{Clickmeetings.config.host}/ping")
        .with(headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type'=>'application/x-www-form-urlencoded',
          'User-Agent'=>'Faraday v0.9.2',
          'X-Api-Key'=>'qwer'
        })
        .to_return(status: 200, body: "{\"ping\":\"pong\"}")
    end

    it "responds with pong" do
      res = subject.get "ping", {}, {"X-Api-Key" => "qwer"}
      expect(res).to eq({"ping" => "pong"})
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

  context "#request when client doesn't respond method" do
    subject { client.request :set, "client" }

    specify { expect { subject }.to raise_error(Clickmeetings::UndefinedHTTPMethod) }
  end
end
