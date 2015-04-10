describe CallType do
  
  let(:ct) { CallType.new }
  
  before :each do
    ct.load(CALL_TYPES)
  end
  
  describe '#initialize' do
    it "loads three records" do   
      expect(ct.size).to eq 3
    end
  end

  describe '#desc' do
    it "finds invalid call type" do
      expect(ct.desc 'XXXXX').to eq 'Unknown service type - XXXXX'
    end
  
    it "finds valid call type" do
      expect(ct.desc '00002').to eq 'Directory charges'
    end
  end
  
end