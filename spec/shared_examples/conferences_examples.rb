shared_examples 'conferences list' do
  it "responds with array of conferences object", :aggregate_failures do
    expect(subject).to be_instance_of Array
    expect(subject.first).to be_instance_of Clickmeetings::PrivateLabel::Conference
  end
end