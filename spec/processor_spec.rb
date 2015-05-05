require_relative 'spec_helper'

LOG_FILE     = '/tmp/tbrlogfile'
PDF_DIR      = '/tmp/201306'

describe Tbr::Processor do
  
  let(:tbr) { Tbr::Processor.new }
    
  before :each do
    FileUtils.rm_f(LOG_FILE)
    Tbr.log = Logger.new(LOG_FILE)
  end
  
  describe "#initialize" do
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
  
  describe ".logo=" do  
    it "should use default logo if argument is nil" do
      tbr.logo = nil
      expect(tbr.logo).to end_with 'lib/tbr/../logo.jpg'
    end
    
    it "should use a logo with a valid path" do 
      tbr.logo = './spec/data/test_logo.jpg'
      expect(tbr.logo).to eq './spec/data/test_logo.jpg'
    end
    
    it "should use default logo if path is invalid and write log entry" do
      tbr.logo = './spec/data/missing_logo.jpg'
      expect(tbr.logo).to end_with 'lib/tbr/../logo.jpg'
      expect(check_log('could not be found')).to be_truthy
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
      expect(check_log('No output directory')).to be_truthy 
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
      tbr.process(BILLS)
      expect(Dir.exist?(PDF_DIR)).to be_truthy
      expect(Dir.glob("#{PDF_DIR}/summaries/*").count).to eq 1
      expect(Dir.glob("#{PDF_DIR}/details/*").count).to eq 16
      expect(check_log('Empty services list')).to be_truthy
      expect(check_log('completed')).to be_truthy
    end
    
    it "creates summaries" do
      tbr.services = [['0353319583','Adrian','105 Dana Street','103']]
      tbr.process(BILLS)
      expect(Dir.glob("#{PDF_DIR}/summaries/*").count).to eq 2
      expect(check_log('Empty services list')).to be_falsy
      expect(check_log('completed')).to be_truthy
    end
  end

  private
  
  def check_log(sub)
    begin
      File.open(LOG_FILE).each do |line|
        return true if line.include?(sub)
      end
      return false
		rescue Errno::ENOENT
      return false 
    end
  end
end
