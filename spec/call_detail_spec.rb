describe CallDetail do
  
  let(:ct) { CallType.new }
  let(:cd) { CallDetail.new(DC_RECORD,ct) }

  describe '#initialize' do    
    it "should set instance variables" do
      expect(cd.call_type).to eq 'Unknown service type - C5421'
      expect(cd.duration).to eq '00:25:40'
      expect(cd.destination).to eq '53448577'
      expect(cd.area).to eq 'Ballarat'
      expect(cd.start_date).to eq '13/03/2013'
      expect(cd.start_time).to eq '17:17:39'
      expect(cd.cost).to eq 3.34
    end
    
    it "should reject invalid record" do
      expect { CallDetail.new("XX",ct) }.to raise_error ArgumentError
    end
  end
  
end