require "spec_helper"

describe Clickmeetings::Open::Token do
  context 'without conference' do
    %w(all create).each do |m|
      describe "::#{m}" do
        subject { described_class.send m }

        specify { expect { subject }.to raise_error(Clickmeetings::Open::Token::NoConferenceError) }
      end
    end
  end

  context 'with conference' do
    before { described_class.by_conference(conference_id: 1) }

    describe '::all' do
      before { mock_api :get, 'conferences/1/tokens', open: true }

      subject { described_class.all }

      it_behaves_like 'tokens list'
    end

    describe '::create' do
      before { mock_api :post, 'conferences/1/tokens', open: true }

      subject { described_class.create how_many: 2 }

      it_behaves_like 'tokens list'
    end

    describe '#create_hash' do
      before do
        mock_api :get, 'conferences/1', open: true
        mock_api :post, 'conferences/1/room/autologin_hash', open: true
      end

      subject do
        described_class.new(token: 'qweqwe').create_hash(
          nickname: 'makar',
          email: 'qweqew@qweqew.com',
          role: 'listener'
        )
      end

      it 'responds with LoginHash object' do
        expect(subject).to be_an_instance_of(Clickmeetings::Open::LoginHash)
        expect(subject.conference_id).to eq(1)
        expect(subject.token).to eq 'qweqwe'
      end
    end
  end
end
