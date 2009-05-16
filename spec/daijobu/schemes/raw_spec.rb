require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Daijobu::Scheme::Raw do
  
  before do
    @scheme = Daijobu::Scheme::Raw.new
  end
  
  describe "#parse" do
    before do
      @stringy = '{ "thing" => 10 }'
    end
    
    it "should do nothing to the given string" do
      @scheme.parse(@stringy).should == @stringy
    end
    
    describe "when the input string is nil" do
      it "should return nil" do
        @scheme.parse(nil).should be_nil
      end
    end
  end
  
  describe "#unparse" do
    before do
      @hashy = { "thing" => 10 }
    end
    
    it "should do nothing to the given object" do
      @scheme.unparse(@hashy).should == @hashy
    end    
  end
  
end