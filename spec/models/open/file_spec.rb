require "spec_helper"

describe Clickmeetings::Open::FileLibrary do
  describe '::create' do
    before { mock_api :post, 'file-library', open: true }

    subject { described_class.create(path: 'spec/fixtures/presentation.pdf') }

    it "responds with FileLibrary object" do
      expect(subject).to be_an_instance_of(described_class)
    end
  end

  describe '::for_conference' do
    before { mock_api :get, 'file-library/conferences/1', open: true }

    subject { described_class.for_conference(conference_id: 1)  }

    it "responds with an array of files" do
      expect(subject).to be_an_instance_of(Array)
      expect(subject.first).to be_an_instance_of(described_class)
    end
  end

  describe '#download' do
    before do
      stub_request(:get, 'https://api.clickmeeting.com/v1/file-library/1/download')
        .to_return(status: 200,
                   body: File.read('spec/fixtures/presentation.pdf'),
                   headers: {
                     "Content-Type"=>"application/octet-stream",
                     "Content-Length"=>"357552",
                     "Connection"=>"close",
                     "Pragma"=>"public",
                     "Content-Disposition"=>"attachment; filename=\"pdf.pdf\"",
                     "Content-Transfer-Encoding"=>"binary"
                   })
    end

    subject { described_class.new(id: 1).download }

    it "responds with file content" do
      expect(subject).to eq File.read('spec/fixtures/presentation.pdf')
    end
  end
end
