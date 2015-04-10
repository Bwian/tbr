require_relative 'spec_helper'

describe Service do

  let(:service) { Service.new(TEST_PHONE,'Brian Collins','1000') }
  let(:call_type) { CallType.new }
  
  before :each do
    call_type.load(CALL_TYPES)
  end

  describe ".initialize" do
    it "should set service_summaries to empty array" do
      expect(service.service_summaries).to eq []
    end
    
    it "should set call_details to empty array" do
      expect(service.call_details).to eq []
    end
    
    it "should have a zero total" do
      expect(service.total).to eq 0.0
    end
  end
  
  describe "#service_number" do
    it "should initialise service_number" do
      expect(service.service_number).to eq TEST_PHONE
    end
    
    it "shouldn't set service_number" do
      expect { service.service_number = '1234' }.to raise_error NoMethodError
    end
  end
  
  describe "#name" do
    it "should initialise name" do
      expect(service.name).to eq 'Brian Collins'
    end
    
    it "should set provided name" do
      service.name = 'New Name'
      expect(service.name).to eq 'New Name'
    end
    
    it "should set default name" do
      service.name = nil
      expect(service.name).to eq 'Unassigned'
    end
  end
    
  describe "#cost_centre" do
    it "should initialise cost_centre" do
      expect(service.cost_centre).to eq '1000'
    end
  
    it "should set provided cost_centre" do
      service.cost_centre = '1234'
      expect(service.cost_centre).to eq '1234'
    end
  
    it "should set default cost_centre" do
      service.cost_centre = nil
      expect(service.cost_centre).to eq ''
    end
  end
  
  describe "#add_service_summary" do
    it "should add a service" do
      service.add_service_summary(nil)
      expect(service.service_summaries.size).to eq 1
    end
  end
  
  describe "#add_call_detail" do
    it "should add a call_detail" do
      service.add_call_detail(nil)
      expect(service.call_details.size).to eq 1
    end
  end
  
  describe "#total" do
    it "returns a total" do
      service_summary = double('ServiceSummary', cost: 12.34)
      service.add_service_summary(service_summary)
      expect(service.total).to eq 12.34
    end
  end
  
  describe "#service_number_format" do
    context "phone number" do
      it "should format as phone number" do
        expect(service.service_number_format).to eq "04 1850 1461"
      end
    end
    
    context "non-phone service" do
      it "shouldn't format the service number" do
        expect(Service.new('TEST',nil,nil).service_number_format).to eq 'TEST'
      end
    end
  end
end