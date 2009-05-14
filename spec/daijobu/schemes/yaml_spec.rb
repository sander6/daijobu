require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Daijobu::Scheme::YAML do

  before do
    @scheme = Daijobu::Scheme::YAML.new
  end
  
  describe "#parse" do
    before do
      @stringy = '{ "thing" : 10 }'
    end
    
    it "should parse the given string with the YAML module" do
      ::YAML.expects(:load).with(@stringy)
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
      ::YAML.expects(:dump).with(@hashy)
      @scheme.unparse(@hashy)
    end    
  end
  
end