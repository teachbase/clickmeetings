require "spec_helper"

describe Clickmeetings::Open::TimeZone do
  describe '::all' do
    context 'without params' do
      before { mock_api :get, 'time_zone_list/', open: true }

      subject { described_class.all }

      it "responds with an array" do
        expect(subject).to be_an_instance_of(Array)
        expect(subject.count).to eq(420)
      end
    end

    context 'with params' do
      before { mock_api :get, 'time_zone_list/ru', open: true }

      subject { described_class.all country: :ru }

      it "responds with an array" do
        expect(subject).to be_an_instance_of(Array)
        expect(subject.count).to eq(24)
      end
    end
  end
end
