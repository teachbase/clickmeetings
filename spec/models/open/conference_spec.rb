require "spec_helper"

describe Clickmeetings::Open::Conference do
  describe '::all' do
    subject { described_class.all }

    before do
      mock_api(:get, 'conferences/active', open: true)
      mock_api(:get, 'conferences/inactive', open: true)
    end

    it "responds with array of conferences", :aggregate_failures do
      expect(subject).to be_an_instance_of(Array)
      expect(subject.first).to be_an_instance_of(described_class)
    end
  end

  %w(active inactive).each do |m|
    describe "::#{m}" do
      subject { described_class.send m }

      before { mock_api(:get, "conferences/#{m}", open: true) }

      it "responds with array of conferences", :aggregate_failures do
        expect(subject).to be_an_instance_of(Array)
        expect(subject.first).to be_an_instance_of(described_class)
      end 
    end
  end

  describe '::skins' do
    before { mock_api(:get, 'conferences/skins', open: true) }

    subject { described_class.skins }

    it "responds with array of hashes", :aggregate_failures do
      expect(subject).to be_an_instance_of(Array)
      expect(subject.first).to be_an_instance_of(Hash)
    end
  end

  describe '#tokens' do
    before { mock_api(:get, 'conferences/1/tokens', open: true) }

    subject { described_class.new(id: 1).tokens }

    it_behaves_like 'tokens list'
  end

  %w(sessions registrations recordings).each do |m|
    context "##{m}" do
      before { mock_api :get, "conferences/1/#{m}", open: true }

      subject { described_class.new(id: 1).send m }

      it "responds with an array of #{m}" do
        klass = "Clickmeetings::Open::#{m.singularize.capitalize}".constantize
        expect(subject).to be_an_instance_of(Array)
        expect(subject.first).to be_an_instance_of(klass)
      end

      it "response has conference_id" do
        expect(subject.first.conference_id).to eq(1)
      end
    end
  end

  context 'files' do
    before { mock_api :get, "file-library/conferences/1", open: true }

    subject { described_class.new(id: 1).files }

    it "responds with an array of files" do
      expect(subject).to be_an_instance_of(Array)
      expect(subject.first).to be_an_instance_of Clickmeetings::Open::FileLibrary
    end
  end

  describe '#create_tokens' do
    before { mock_api(:post, 'conferences/1/tokens', open: true) }

    subject { described_class.new(id: 1).create_tokens 2 }

    it_behaves_like 'tokens list'

    it "response has conference_id" do
      expect(subject.first.conference_id).to eq(1)
    end
  end

  describe '#create_hash' do
    before do
      mock_api :get, 'conferences/1', open: true
      mock_api :post, 'conferences/1/room/autologin_hash', open: true
    end

    subject do
      described_class.new(id: 1).create_hash(
        nickname: 'qwe',
        email: 'qwe',
        role: 'listener',
        token: 'qweqwe'
      )
    end

    it "responds with LoginHash object" do
      expect(subject).to be_an_instance_of(Clickmeetings::Open::LoginHash)
      expect(subject.conference_id).to eq(1)
    end
  end

  describe '#send_invites' do
    before { mock_api(:post, 'conferences/1/invitation/email/en', open: true) }
    subject { described_class.new(id: 1).send_invites(attendees: [{email: "q@q.qq"}], role: "listener") }

    it "responds with Invitation object" do
      expect(subject).to be_an_instance_of(Clickmeetings::Open::Invitation)
      expect(subject.conference_id).to eq 1
    end
  end

  describe '#register' do
    before { mock_api :post, "conferences/1/registration", open: true }

    let(:params) { {registration: {1 => "qwer", 2 => 'qwer', 3 => 'qwer@qwer.qw'}} }
    subject { described_class.new(id: 1).register(params) }

    it "responds with hash" do
      expect(subject).to be_an_instance_of(Hash)
    end
  end
end
