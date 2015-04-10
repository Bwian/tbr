require_relative 'spec_helper'

NAME     = 'name'
SERVICE  = 'mock service'

describe Group do

  let(:group) { Group.new(NAME) }

  describe ".initialize" do
    it "should create an empty group array" do
      expect(group.size).to eq 0
    end
  end
  
  describe "#add_service" do
    it "should add a service" do
      group.add_service(SERVICE)
      expect(group.size).to eq 1
    end
  end
  
  describe "#name" do
    it "should return initial name" do
      expect(group.name).to eq NAME   
    end
    
    it "shouldn't set name" do
      expect { group.name = 'new name' }.to raise_error NoMethodError
    end
  end
  
  describe "#each" do
    it "should return two groups" do
      count = 0
      group.add_service(SERVICE)
      group.add_service(SERVICE)
      group.each { count += 1}
      expect(count).to eq 2
    end
  end
  
end