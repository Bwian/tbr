require_relative 'spec_helper'
#require 'tbr/processor'

LOG_DEFAULT  = '/tmp/tbr.log'
LOG_FILE     = '/tmp/tbrlogfile'
LOG_MISSING  = '/tmp/tbr/missing.log'
LOG_READONLY = './spec/data/readonly.log'
PDF_SUBDIR   = '201306'

describe Tbr::Processor do
  
  let(:tbr) { Tbr::Processor.new }
  
  describe ".process" do
    it "raises an ArgumentError if file argument not provided" do
      expect { tbr.process(one: 1) }.to raise_error ArgumentError
    end
    
    it "raises an ArgumentError if extra options not Hash" do
      expect { tbr.process('file',2) }.to raise_error ArgumentError
    end
    
    it "raises an IOError if input file not found" do
      expect { tbr.process(MISSING) }.to raise_error IOError
    end
  end
  
  describe ".process - logging" do
    before :each do
      FileUtils.rm_f(LOG_DEFAULT)
      FileUtils.rm_f(LOG_FILE)
    end
    
    it "writes to logfile if log directory is valid" do
      process(BILLS, log: LOG_FILE)
      expect(check_file(LOG_FILE)).to be_truthy
    end
    
    it "writes to /tmp if log directory is invalid" do
      process(BILLS, log: LOG_MISSING)
      expect(check_file(LOG_DEFAULT)).to be_truthy
    end
    
    it "writes to /tmp if log argument not provided" do
      process(BILLS,{})
      expect(check_file(LOG_DEFAULT)).to be_truthy
    end
    
    it "writes to /tmp if the logfile cannot be written" do
      process(BILLS, log: LOG_READONLY)
      expect(check_file(LOG_READONLY)).to be_falsy
      expect(check_file(LOG_DEFAULT)).to be_truthy
    end
  end
  
  describe ".process - writing output" do
    before :each do
      FileUtils.rm_rf("#{OUT_DIR}/#{PDF_SUBDIR}")
      FileUtils.rm_rf("/tmp/#{PDF_SUBDIR}")
      FileUtils.rm_f(LOG_DEFAULT)
    end
    
    it "writes to output if directory is valid", pdf: true do
      process(BILLS, output: OUT_DIR)
      expect(Dir.exist?("#{OUT_DIR}/#{PDF_SUBDIR}")).to be_truthy
    end
    
    it "writes to /tmp if directory is invalid", pdf: true do
      process(BILLS, output: "/tmp/#{PDF_SUBDIR}")
      expect(Dir.exist?("/tmp/#{PDF_SUBDIR}")).to be_truthy
    end
    
    it "writes to /tmp if output argument not provided", pdf: true do
      process(BILLS,{})
      expect(Dir.exist?("/tmp/#{PDF_SUBDIR}")).to be_truthy
    end 
  end
  
  private
  
  def process(file,options)
    begin
      tbr.process(file, options)
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