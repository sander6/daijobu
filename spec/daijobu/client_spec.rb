require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Daijobu::Client do
  
  before do
    @casket = Rufus::Tokyo::Cabinet.new('*')
  end
  
  describe "initialization" do
    
    it "should set the adapter based on the casket object given" do
      Daijobu::Adapter.expects(:get).with(@casket)
      Daijobu::Client.new(@casket)
    end
    
    it "should set the schemes based on the scheme list given" do
      Daijobu::SchemeSet.expects(:new).with(:json, :yaml)
      Daijobu::Client.new(@casket, :json, :yaml)
    end

  end

  describe "methods" do
    before do
      @daijobu = Daijobu::Client.new(@casket)
    end

    describe "for getting and setting" do
      before do
        @adapter = @daijobu.instance_variable_get(:@adapter)
        @stringy = "woohoo!"
      end
      
      describe "#[]" do            
        it "should call #get on the adapter" do
          @adapter.expects(:get).with('key')
          @daijobu['key']
        end
      end

      describe "#[]=" do
        before do
          @daijobu.stubs(:unparse).returns(@stringy)
        end
        
        it "should call set on the adapter" do
          @adapter.expects(:set).with('key', @stringy)
          @daijobu['key'] = @stringy
        end
      end
    end
    

    describe "for parsing and unparsing" do
      before do
        @schemes = @daijobu.instance_variable_get(:@schemes)
        @stringy = "woohoo!"
      end
      
      describe "#parse" do
        it "should call parse on the schemes" do
          @schemes.expects(:parse).with(@stringy)
          @daijobu.__send__(:parse, @stringy)
        end
      end
    
      describe "#unparse" do
        it "should call unparse on the schemes" do
          @schemes.expects(:unparse).with(@stringy)
          @daijobu.__send__(:unparse, @stringy)
        end
      end
    end
  end
  
end