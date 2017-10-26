shared_examples 'tokens list' do
  it "responds with an array of Token", :aggregate_failures do
    expect(subject).to be_an_instance_of(Array)
    expect(subject.first).to be_an_instance_of(Clickmeetings::Open::Token)
  end
end