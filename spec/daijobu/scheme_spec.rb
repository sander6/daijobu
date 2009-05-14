require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Daijobu::Scheme do
  
  describe ".get" do
    
    describe "with :marshal" do
      it "should return a marshal scheme" do
        Daijobu::Scheme.get(:marshal).should be_an_instance_of(Daijobu::Scheme::Marshal)
      end
    end

    describe "with :json" do
      it "should return a json scheme" do
        Daijobu::Scheme.get(:json).should be_an_instance_of(Daijobu::Scheme::JSON)
      end
    end

    describe "with :yaml" do
      it "should return a yaml scheme" do
        Daijobu::Scheme.get(:yaml).should be_an_instance_of(Daijobu::Scheme::YAML)
      end
    end

    describe "with :eval" do
      it "should return a eval scheme" do
        Daijobu::Scheme.get(:eval).should be_an_instance_of(Daijobu::Scheme::Eval)
      end
    end
    
    describe "with anything else" do
      it "should raise an error" do
        lambda { Daijobu::Scheme.get(:xml) }.should raise_error(Daijobu::UnknownScheme)
      end
    end
    
  end
  
end