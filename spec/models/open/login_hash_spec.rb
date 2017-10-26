require "spec_helper"

describe Clickmeetings::Open::LoginHash do
  describe '::create' do
    let(:params) do
      {
        conference_id: 1, nickname: 'makar', email: 'qwer@qwer.qw',
        token: Clickmeetings::Open::Token.new(token: "QWEQWE"),
        role: 'listener'
      }
    end

    before do
      mock_api(:get, 'conferences/1', open: true)
      mock_api(:post, 'conferences/1/room/autologin_hash', open: true)
    end

    subject { described_class.create(params) }

    it "responds with LoginHash object", :aggregate_failures do
      expect(subject).to be_an_instance_of(described_class)
      expect(subject.conference_id).to eq(1)
      expect(subject.nickname).to eq('makar')
      expect(subject.email).to eq('qwer@qwer.qw')
      expect(subject.role).to eq('listener')
      expect(subject.token).to eq("QWEQWE")
    end

    context 'validation' do
      %i(conference_id nickname email role token).each do |opt_name|
        context opt_name.to_s do
          let(:bad_params) do
            p = params
            p[opt_name] = nil
            p
          end

          subject { described_class.create(bad_params) }

          specify { expect { subject }.to raise_error(described_class::InvalidParamsError) }
        end
      end

      context 'password' do
        before do
          mock_api(:get, 'conferences/2', open: true)
        end

        let(:bad_params) do
          { conference_id: 2, nickname: 'makar', email: 'qwe@qwe.qw', role: 'listener' }
        end

        subject { described_class.create(bad_params) }

        specify { expect { subject }.to raise_error(described_class::InvalidParamsError) }
      end
    end
  end
end
