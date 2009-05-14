require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Daijobu::Scheme::Marshal do
  
  before do
    @scheme = Daijobu::Scheme::Marshal.new
  end
  
  describe "#parse" do
    before do
      @stringy = "\004\b{\006\"\nthingi\017"
    end
    
    it "should parse the given string with the Marshal module" do
      ::Marshal.expects(:load).with(@stringy)
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
    
    it "should unparse the given object with the JSON module" do
      ::Marshal.expects(:dump).with(@hashy)
      @scheme.unparse(@hashy)
    end    
  end

end