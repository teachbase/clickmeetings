require "spec_helper"

describe 'WithLocale' do
  before(:all) do
    class TestClassWithLocale < Clickmeetings::Open::Model
      include Clickmeetings::Open::WithLocale
    end
  end

  let(:described_class) { TestClassWithLocale }

  describe '::with_locale' do
    subject { described_class.with_locale("ru") { described_class.locale } }

    it "uses specified locale in block" do
      expect(subject).to eq("ru")
    end

    it "uses default locale out of block" do
      expect(described_class.locale).to eq(:en)
    end
  end
end
