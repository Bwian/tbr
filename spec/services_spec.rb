require_relative 'spec_helper'

ONE   = '1234'
TWO   = '2345'
THREE = '3456'

describe Services do

  let(:services) { Services.new }
  
  before :each do
    services.service ONE
    services.service TWO
  end

  describe "#size" do
    it "should contain two services" do
      expect(services.size).to eq 2
    end
  end
  
  describe "#service" do
    it "should return a Service" do
      service = services.service ONE
      expect(service.class).to eq Service
    end
    
    context "no service number" do
      it "shouldn't add nil service number" do
        services.service(nil)
        expect(services.size).to eq 2
      end
      
      it "shouldn't add empty service number" do
        services.service('')
        expect(services.size).to eq 2
      end
    end
    
    context "pre-existing service number" do
      it "shouldn't add a service" do
        services.service ONE
        expect(services.size).to eq 2
      end
    end
    
    context "new service number" do
      it "should add a service" do
        services.service THREE
        expect(services.size).to eq 3
      end
    end
  end
  
  describe "#each" do
    it "should return two services" do
      count = 0
      services.each { count += 1}
      expect(count).to eq 2
    end
  end
  
  describe "#delete" do
    it "should delete a service" do
      services.delete(ONE)
      expect(services.size).to eq 1
    end
  end
  
  describe "#name" do
    it "should return unassigned" do
      expect(services.name).to eq "Unassigned"
    end
  end
  
end