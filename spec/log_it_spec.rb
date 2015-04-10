describe LogIt do
  
  it "should be a singleton" do
    a = LogIt.instance
    b = LogIt.instance
    expect(a).to eq(b)
  end
  
  describe "#to_file" do
    let(:log) { LogIt.instance }
    let(:fname) { './spec/test.log' }
    
    context "log file name supplied" do
      it "writes the log file" do   
    		log_test('to_file',log,fname,[fname])
        expect(File.size(fname)).to be > 0
      end
    end
    
    context "log file name not supplied" do
      it "doesn't write the log file" do      
        log_test('to_null',log,fname,[])
        expect(File.size(fname)).to eq 0
      end
    end
    
    after :each do
      FileUtils.rm_f(fname)
      log.to_null
    end
  end

  private
  
  def log_test(method,log,fname,args)
    FileUtils.rm_f(fname)
		log.to_file(fname)
    log.close
    log.send(method,*args)
		log.warn("Hello World")
		log.close 
  end
end