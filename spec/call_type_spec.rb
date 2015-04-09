describe CallType do
  
  let(:ct) { Call_Type.new }
  
  before :each do
    ct.load('./spec/data/call_types.csv')
  end
  
  it "loads three records" do   
    expect(ct.size).to eq 3
  end

end