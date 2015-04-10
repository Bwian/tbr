describe ParseFiles do
  
  let(:sf) { ParseFiles.parse_services_file(SERVICES) }

  describe '.parse_services_file' do    
    context "valid services file" do
      it "should return an array with fourteen elements" do
        expect(sf.size).to eq 14
      end
      
      it "should contain something" do
        fields = sf[10]
        expect(fields[0]).to eq '0353392988'
        expect(fields[1]).to eq 'Unknown'
        expect(fields[2]).to start_with '15 Violet Grove'
        expect(fields[3]).to be nil
      end
    end
    
    context "empty services file" do
      it "should return an empty array" do
        expect(ParseFiles.parse_services_file(EMPTY)).to be_empty
      end
    end
    
    context "invalid services file" do
      it "should return an empty array" do
        expect(ParseFiles.parse_services_file(INVALID)).to be_empty
      end
    end
    
    context "missing services file" do
      it "should throw an exception" do
        expect { ParseFiles.parse_services_file(MISSING) }.to raise_error IOError
      end
    end
  end
    
end