require_relative 'spec_helper'

ONE   = '1234'
TWO   = '2345'
THREE = '3456'

describe Groups do

  let(:groups) { Groups.new }
  
  before :each do
    groups.group ONE
    groups.group TWO
  end

  describe "#size" do
    it "should contain two groups" do
      expect(groups.size).to eq 2
    end
  end
  
  describe "#group" do
    it "should return a Service" do
      group = groups.group ONE
      expect(group.class).to eq Group
    end
    
    context "no group number" do
      it "shouldn't add nil group number" do
        groups.group(nil)
        expect(groups.size).to eq 2
      end
      
      it "shouldn't add empty group number" do
        groups.group('')
        expect(groups.size).to eq 2
      end
    end
    
    context "pre-existing group number" do
      it "shouldn't add a group" do
        groups.group ONE
        expect(groups.size).to eq 2
      end
    end
    
    context "new group number" do
      it "should add a group" do
        groups.group THREE
        expect(groups.size).to eq 3
      end
    end
  end
  
  describe "#each" do
    it "should return two groups" do
      count = 0
      groups.each { count += 1}
      expect(count).to eq 2
    end
  end

end