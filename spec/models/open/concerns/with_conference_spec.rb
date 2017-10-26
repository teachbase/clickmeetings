require 'spec_helper'

describe 'WithConference' do
  before(:all) do
    class TestClassWithConference < Clickmeetings::Open::Model
      include Clickmeetings::Open::WithConference
    end
  end

  let(:described_class) { TestClassWithConference }

  describe '::by_conference' do
    context 'when use without block' do
      subject { described_class.conference_id }

      specify do
        described_class.by_conference conference_id: 1
        expect(subject).to eq 1
      end

      context 'gives conference_id to objects' do
        subject { described_class.new.conference_id }

        specify do
          described_class.by_conference conference_id: 1
          expect(subject).to eq 1
        end
      end
    end

    context 'when use with block' do
      subject do
        described_class.by_conference conference_id: 1 do
          described_class.conference_id
        end
      end

      it "uses specified conference_id in block" do
        expect(subject).to eq 1
      end

      it "hasn't conference_id out of block" do
        expect(described_class.conference_id).to be_nil
      end
    end
  end

  describe '#remote_url' do
    subject { described_class.by_conference(conference_id: 1).remote_url(:all) }

    it "uses conference prefix" do
      expect(subject).to match(/^conferences\/1\//)
    end
  end
end
