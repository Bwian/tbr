require_relative 'spec_helper'
require 'tbr'

describe Tbr do

  describe "#process" do
    it "raises an ArgumentError if file argument not provided" do
      expect { Tbr.process(one: 1) }.to raise_error ArgumentError
    end
    
    it "raises an ArgumentError if extra options not Hash" do
      expect { Tbr.process('file',2) }.to raise_error ArgumentError
    end
    
    it "raises an IOError if input file not found" do
      expect { Tbr.process(MISSING) }.to raise_error IOError
    end
  end
  
end