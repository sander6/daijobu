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
  end
  
  describe "set" do
    it "should call #set on the store and write as raw" do
      @stubby.expects(:set).with('key', 'value', 0, true)
      @adapter.set('key', 'value')
    end
  end
  
end