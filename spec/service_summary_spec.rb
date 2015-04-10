describe ServiceSummary do
  
  let(:ct) { CallType.new }
  let(:ss) { ServiceSummary.new(DS_RECORD,ct) }

  describe '#initialize' do    
    it "should set instance variables" do
      expect(ss.service_number).to eq TEST_PHONE
      expect(ss.call_type).to eq 'Unknown service type - C5421'
      expect(ss.service_type).to eq 'MobileNet'
      expect(ss.units).to eq 'calls'
      expect(ss.call_count).to eq 67
      expect(ss.start_date).to eq '12/03/2013'
      expect(ss.end_date).to eq '10/04/2013'
      expect(ss.cost).to eq 46.48
    end
    
    it "should reject invalid record" do
      expect { ServiceSummary.new("XX",ct) }.to raise_error ArgumentError
    end
  end
  
  describe '#to_a' do
    it "should return an array with five elements" do
      expect(ss.to_a.size).to eq 5
    end
    
    it "should return the correct result" do
      expect(ss.to_a[4]).to eq '46.48'
    end
  end
end