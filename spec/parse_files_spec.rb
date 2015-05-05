describe ParseFiles do
  
  let(:service_list) { ParseFiles.parse_services_file(SERVICES) }
  let(:services) { Services.new }
  let(:groups) { Groups.new }

  describe '.parse_services_file' do    
    context "valid services file" do
      it "should return an array with fourteen elements" do
        expect(service_list.size).to eq 14
      end
      
      it "should contain something" do
        fields = service_list[10]
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
  
  describe ".map_services" do
    before :each do
      ParseFiles.map_services(groups,services,service_list)
    end
    
    it "should create 3 groups" do
      expect(groups.size).to eq 3
    end
    
    it "should create 14 services" do
      expect(services.size).to eq 14
    end
  end
  
  describe ".parse_bill_file" do
    let(:call_type) { CallType.new }
  
    before :each do
      call_type.load(CALL_TYPES)
      @invoice_date = ParseFiles.parse_bill_file(services,call_type,BILLS)
    end
    
    it "returns invoice date" do
      expect(@invoice_date).to eq '20130619'
    end
    
    it "collates services" do
      service = services.service('0418133125')
      expect(service.service_summaries.size).to eq 8
      expect(service.call_details.size).to eq 147
    end
    
    context "missing bill file" do
      it "should throw an exception" do
        expect { ParseFiles.parse_bill_file(services,call_type,MISSING) }.to raise_error IOError
      end
    end
    
    context "invalid bill file" do
      it "should throw an exception" do
        expect { ParseFiles.parse_bill_file(services,call_type,INVALID) }.to raise_error ArgumentError
      end
    end
  end
    
end