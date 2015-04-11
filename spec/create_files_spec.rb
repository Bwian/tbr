describe CreateFiles do
  
  let(:cf) { CreateFiles.new('20130418',OUT_DIR,false) }
  
  before :each do
    FileUtils.rm_rf("#{OUT_DIR}/201304")
  end
  
  describe '.initialize' do    
    it "should set instance variables" do
      expect(cf.invoice_month).to eq 'April 2013'
      expect(cf.dir_root).to eq "#{OUT_DIR}/201304"
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
  
end