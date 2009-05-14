require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Daijobu::Scheme::Eval do
  
  before do
    @scheme = Daijobu::Scheme::Eval.new
  end
  
  describe "#parse" do
    before do
      @stringy = '{ "thing" => 10 }'
    end
    
    it "should parse the given string using Kernel::eval" do
      @scheme.expects(:eval).with(@stringy)
      @scheme.parse(@stringy)
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
    
    it "should inspect the given object" do
      @hashy.expects(:inspect)
      @scheme.unparse(@hashy)
    end    
  end
  
end