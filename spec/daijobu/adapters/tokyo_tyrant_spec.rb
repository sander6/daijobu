require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Daijobu::Adapter::TokyoTyrantAdapter do
  
  before do
    @stubby   = stub('fake store')
    @adapter  = Daijobu::Adapter::TokyoTyrantAdapter.new(@stubby)
  end
  
  describe "#get" do
    it "should call #[] on the store" do
      @stubby.expects(:[]).with('key')
      @adapter.get('key')
    end
  end
  
  describe "set" do
    it "should call #set on the store and write as raw" do
      @stubby.expects(:[]=).with('key', 'value')
      @adapter.set('key', 'value')
    end
  end
  
end