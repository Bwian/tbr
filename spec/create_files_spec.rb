describe CreateFiles do
  
  let(:cf) { CreateFiles.new('20130418',OUT_DIR,true) }
  
  before :all do
    LogIt.instance.to_null
  end
  
  before :each do
    FileUtils.rm_rf("#{OUT_DIR}/201304")
  end
  
  describe '.initialize' do    
    it "should set instance variables" do
      expect(cf.invoice_month).to eq 'April 2013'
      expect(cf.dir_root).to eq "#{OUT_DIR}/201304"
      expect(cf.logo).to be_nil
      expect(Dir.exist?("#{OUT_DIR}/201304/summaries")).to be_truthy
      expect(Dir.exist?("#{OUT_DIR}/201304/details")).to be_truthy
    end
    
    context "invalid invoice date" do
      it "should throw an exception" do
        expect { CreateFiles.new('','/tmp',false) }.to raise_error ArgumentError
      end
    end
    
    context "directory already exists" do
      it "should throw an exception" do
        CreateFiles.new('20130418',OUT_DIR,false)
        expect { CreateFiles.new('20130418',OUT_DIR,false) }.to raise_error IOError
      end
    end
  end
  
  describe '#dir_full_root' do
    it "should return the full pathname" do
      expect(cf.dir_full_root).to include '/tbr/'
    end
  end
  
  describe '#logo=' do
    it "should set the logo file path" do
      cf.logo = '/tmp/logo.jpg'
      expect(cf.logo).to eq '/tmp/logo.jpg'
    end
  end
  
  describe 'pdf file creation methods should return no error in:', pdf: true do
    before :all do
      @groups = Groups.new
      @services = Services.new
      call_type = CallType.new
      call_type.load(CALL_TYPES)
      service_list = ParseFiles.parse_services_file(SERVICES)
      ParseFiles.map_services(@groups,@services,service_list)
      @invoice_date = ParseFiles.parse_bill_file(@services,call_type,BILLS)
    end
  
    it '#group_summary' do   
      count = 0
      @groups.each do |group|
        cf.group_summary(group)
        count += 1
      end
      expect(count).to eq 3
    end
    
    it '#call_details' do   
      count = 0
      @services.each do |service|
        cf.call_details(service)
        count += 1
      end
      expect(count).to eq 16
    end
    
    it '#service_totals' do
      cf.service_totals(@services)
    end
  end
  
end