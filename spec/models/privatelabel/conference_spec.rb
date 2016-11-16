require "spec_helper"

describe Clickmeetings::PrivateLabel::Conference do
  context '::by_account' do
    context "without block" do
      before { described_class.by_account(account_id: 1) }
      after(:all) { described_class.by_account(account_id: nil) }

      subject { described_class.account_id }

      specify { expect(subject).to eq 1 }

      context "gives account_id to objects" do
        subject { described_class.new.account_id }

        specify { expect(subject).to eq 1 }
      end
    end

    context 'with block' do
      subject do
        described_class.by_account account_id: 1 do
          described_class.account_id
        end
      end

      it "uses specified account_id in block" do
        expect(subject).to eq 1
      end

      it "hasn't account_id out of block" do
        expect(described_class.account_id).to be_nil
      end
    end
  end

  context 'without account' do
    context "::find" do
      subject { described_class.find(1) }

      specify do
        expect { subject }.to raise_error Clickmeetings::PrivateLabel::Conference::NoAccountError
      end
    end

    %w(all create).each do |method|
      context "::#{method}" do
        subject { described_class.send method }

        specify do
          expect { subject }.to raise_error Clickmeetings::PrivateLabel::Conference::NoAccountError
        end
      end
    end

    %w(update destroy).each do |method|
      context "##{method}" do
        subject { described_class.new.send(method) }

        specify do
          expect { subject }.to raise_error Clickmeetings::PrivateLabel::Conference::NoAccountError
        end
      end
    end
  end

  context "with account" do
    before { described_class.by_account(account_id: 1) }
    after(:all) { described_class.by_account(account_id: nil) }

    context '::find' do
      subject { described_class.find(1) }

      before(:each) { mock_api(:get, 'accounts/1/conferences/1') }

      it "responds with Conference object" do
        expect(subject).to be_instance_of described_class
      end
    end

    context '::all' do
      before(:each) { mock_api(:get, "accounts/1/conferences") }
      subject { described_class.all }

      it_behaves_like 'conferences list'
    end

    context '::create' do
      before(:each) { mock_api(:post, "accounts/1/conferences", 201) }
      let(:params) do
        {
          name: "New Api Room",
          room_name: "new_api_room",
          lobby_description: "Wait some minutes",
          room_type: "webinar",
          permanent_room: 0,
          starts_at: "2016-11-04T23:44:39+0300",
          ends_at: "2016-11-05T23:44:39+0300",
          lobby_enabled: 1,
          access_type: 1,
          password: "qwerty"
        }
      end
      subject { described_class.create params }

      it "returns Conference object" do
        expect(subject).to be_an_instance_of(described_class)
      end

      it "has correct properties", :aggregate_failures do
        expect(subject.access_role_hashes).to eq({
          "listener" => "0cb61e2dd0ae19c8eb252900581baedc",
          "presenter" => "acd6afeeb487cd1eb6985e00581baedc",
          "host" => "49b57914e6d00ed141ea1e00581baedc"
        })
        expect(subject.access_type).to eq 1
        expect(subject.account_id).to eq 1
        expect(subject.ccc).to eq "2016-11-04 20:44:00"
        expect(subject.created_at).to eq "2016-11-03T21:40:44+00:00"
        expect(subject.description).to eq ""
        expect(subject.embed_room_url).to eq "http://embed.anysecond.com/embed_conference.html?r=16531165866647"
        expect(subject.ends_at).to eq "2016-11-04T23:44:00+00:00"
        expect(subject.id).to eq 1
        expect(subject.lobby_description).to eq "Wait some minutes"
        expect(subject.name).to eq "newnewn"
        expect(subject.name_url).to eq "newnewn"
        expect(subject.permanent_room).to be_falsey
        expect(subject.phone_listener_pin).to eq 869828
        expect(subject.phone_presenter_pin).to eq 538883
        expect(subject.recorder_list).to be_empty
        expect(subject.room_pin).to eq 884449349
        expect(subject.room_type).to eq "webinar"
        expect(subject.room_url).to eq "http://testapi.anysecond.com/newnewn"
        expect(subject.starts_at).to eq "2016-11-04T20:44:00+00:00"
        expect(subject.status).to eq "active"
        expect(subject.updated_at).to eq "2016-11-03T21:40:44+00:00"
      end
    end

    context '#update' do
      let(:object) { described_class.new(id: 1, access_type: 3, name: 'New Name') }
      subject { object.update access_type: 1 }

      before(:each) { mock_api(:put, 'accounts/1/conferences/1') }

      specify { expect(subject).to be_an_instance_of described_class }

      it "returns updated object" do
        expect(subject.access_type).to eq 1
      end
    end

    context "#destroy" do
      let(:object) { described_class.new(id: 1, name: "Name") }
      subject { object.destroy }

      before(:each) { mock_api(:delete, 'accounts/1/conferences/1') }

      specify { expect(subject).to be_an_instance_of described_class }
    end
  end
end
