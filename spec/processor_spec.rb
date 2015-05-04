require_relative 'spec_helper'

LOG_DEFAULT  = '/tmp/tbr.log'
LOG_FILE     = '/tmp/tbrlogfile'
LOG_MISSING  = '/tmp/tbr/missing.log'
LOG_READONLY = './spec/data/readonly.log'
PDF_DIR      = '/tmp/201306'

#TODO: :original
describe Tbr::Processor do
  
  let(:tbr) { Tbr::Processor.new }
  
  before :each do
    FileUtils.rm_f(LOG_DEFAULT)
    FileUtils.rm_f(LOG_FILE)
    tbr.log = LOG_FILE
  end
  
  describe "#initialize" do
    it "should set log to default" do  
      expect(Tbr::Processor.new.logpath).to be_falsy
    end
    
    it "should set logo to default" do
      expect(tbr.logo).to include 'lib/tbr/../logo.jpg'
    end
    
    it "should set replace to false" do
      expect(tbr.replace).to be_falsy
    end
    
    it "should set services to an empty array" do
      expect(tbr.services).to eq []
    end
  end
  
  describe ".import_services" do
    it "should import data in tbr.services" do
      tbr.import_services(SERVICES)
      expect(tbr.services.count).to eq 14
    end
  end
  
  describe ".log=" do
    context "with no log path" do
      it "should log nowhere" do
        tbr.log = nil
        expect(tbr.logpath).to eq nil
      end
    
      it "should log to STDOUT" do
        tbr.log = STDOUT
        expect(tbr.logpath).to eq nil
      end
    
      it "should log to STDERR" do
        tbr.log = STDERR
        expect(tbr.logpath).to eq nil
      end
    end
    
    it "should log to LOG_DEFAULT if logpath is invalid" do
      tbr.log = LOG_MISSING
      expect(tbr.logpath).to eq LOG_DEFAULT
      expect(check_file(LOG_DEFAULT)).to be_truthy
    end
    
    it "should raise a TbrError if neither path is writable" do 
      FileUtils.touch(LOG_DEFAULT)
      FileUtils.chmod(0444,LOG_DEFAULT)
      expect { tbr.log = LOG_MISSING }.to raise_error Tbr::TbrError
    end
    
    it "should log nowhere if file argument isn't a string" do
      tbr.log = []
      expect(tbr.logpath).to eq nil
    end
    
    describe "logs to", pdf: true do
      before :each do
        FileUtils.rm_rf(PDF_DIR)
        tbr.replace = true
      end
      
      it "if log directory is valid" do
        process(BILLS)
        expect(check_file(LOG_FILE)).to be_truthy
      end
      
      it "should write to /tmp if log directory is invalid" do
        tbr.log = LOG_MISSING
        process(BILLS)
        expect(check_file(LOG_DEFAULT)).to be_truthy
      end  
    end
  end
  
  describe ".logo=" do  
    it "should use default logo if argument is nil" do
      tbr.logo = nil
      expect(tbr.logo).to end_with 'lib/tbr/../logo.jpg'
      expect(check_file(LOG_FILE)).to be_falsy
    end
    
    it "should use a logo with a valid path" do 
      tbr.logo = './spec/data/test_logo.jpg'
      expect(tbr.logo).to eq './spec/data/test_logo.jpg'
      expect(check_file(LOG_FILE)).to be_falsy
    end
    
    it "should use default logo if path is invalid and write log entry" do
      tbr.logo = './spec/data/missing_logo.jpg'
      expect(tbr.logo).to end_with 'lib/tbr/../logo.jpg'
      expect(check_file(LOG_FILE)).to be_truthy
    end
  end
  
  describe ".output=" do
    it "should output to /tmp if argument is nil" do
      tbr.output = nil
      expect(tbr.output).to eq '/tmp'
    end
    
    it "should output to supplied directory if directory exists" do
      tbr.output = OUT_DIR
      expect(tbr.output).to eq OUT_DIR
    end
    
    it "should output to /tmp if output directory doesn't exist" do
      tbr.output = "#{OUT_DIR}/missing"
      expect(tbr.output).to eq '/tmp'
      expect(check_file(LOG_FILE)).to be_truthy 
    end
  end
  
  describe ".services=" do
    it "should set services to a valid array" do
      tbr.services = [1,2,3]
      expect(tbr.services).to eq [1,2,3]
    end
    
    it "should raise an ArgumentError when service isn't an array" do
      expect { tbr.services = 'error' }.to raise_error ArgumentError
    end
  end
 
  describe ".process" do
    it "raises an ArgumentError if argument is not a string" do
      expect { tbr.process(nil) }.to raise_error ArgumentError
    end
    
    it "raises an IOError if input file not found" do
      expect { tbr.process(MISSING) }.to raise_error IOError
    end
  end
  
  describe ".process - writing output", pdf: true do
    before :each do
      FileUtils.rm_rf(PDF_DIR)
      tbr.output = '/tmp'
    end
    
    it "writes to output if directory is valid" do
      process(BILLS)
      expect(Dir.exist?(PDF_DIR)).to be_truthy
      expect(Dir.glob("#{PDF_DIR}/summaries/*").count).to eq 1
      expect(Dir.glob("#{PDF_DIR}/details/*").count).to eq 16
    end
    
    it "creates summaries" do
      tbr.services = [['0353319583','Adrian','105 Dana Street','103']]
      process(BILLS)
      expect(Dir.glob("#{PDF_DIR}/summaries/*").count).to eq 2
    end
  end

  private
  
  def process(file)
    begin
      tbr.process(file)
    rescue  
    end
  end
  
  def check_file(fname)
    begin
      size = File.open(fname).size
		rescue Errno::ENOENT
      return false 
    end
    size > 0 
  end
end
