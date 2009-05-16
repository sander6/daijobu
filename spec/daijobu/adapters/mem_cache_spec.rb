require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Daijobu::Adapter::MemCacheAdapter do
  
  before do
    @stubby   = stub('fake store')
    @adapter  = Daijobu::Adapter::MemCacheAdapter.new(@stubby)
  end
  
  describe "#get" do
    it "should call #get on the store and read as raw" do
      @stubby.expects(:get).with('key', true)
      @adapter.get('key')
    end
    
    describe "with no arguments" do
      it "should return nil" do
        @adapter.get.should be_nil
      end
    end
    
    describe "with multiple arguments" do
      it "should call #get for each key" do
        @stubby.expects(:get).times(3)
        @adapter.get('key1', 'key2', 'key3')
      end
      
      it "should return a hash" do
        @stubby.stubs(:get)
        @adapter.get('key1', 'key2', 'key3').should be_an_instance_of(Hash)
      end
    end
  end
  
  describe "set" do
    it "should call #add on the store and write as raw" do
      @stubby.expects(:add).with('key', 'value', 0, true)
      @adapter.set('key', 'value')
    end
  end
  
end