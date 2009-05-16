require File.dirname(__FILE__) + '/../spec_helper'

describe Daijobu::NamespaceProxy do
  
  before do
    @daijobu = stub('fake-daijobu-client!')
  end
  
  describe "initialization" do

    it "should set the owner as the given owner" do
      Daijobu::NamespaceProxy.new(@daijobu, 'prefix').instance_variable_get(:@owner).should == @daijobu
    end
    
    it "should set the namespace as the given namespace" do
      Daijobu::NamespaceProxy.new(@daijobu, 'prefix').instance_variable_get(:@namespace).should == 'prefix'
    end
    
    it "should be indifferent to strings or symbols as the namespace" do
      Daijobu::NamespaceProxy.new(@daijobu, :prefix).instance_variable_get(:@namespace).should == 'prefix'
    end
    
    it "should initialize with the class-level default separator" do
      Daijobu::NamespaceProxy.new(@daijobu, 'prefix').instance_variable_get(:@separator).should == Daijobu::NamespaceProxy.default_separator
    end
    
    it "should set the separator as the given separator" do
      Daijobu::NamespaceProxy.new(@daijobu, 'prefix', '/').instance_variable_get(:@separator).should == '/'
    end
    
  end

  describe "methods" do
    before do
      @proxy = Daijobu::NamespaceProxy.new(@daijobu, 'prefix')
    end
    
    describe "#[]" do
      it "should send #[] with the namespaced key to the owner" do
        @daijobu.expects(:[]).with('prefix:key')
        @proxy['key']
      end
    end
    
    describe "#[]=" do
      it "should send #[]= with the namespaced key to the owner" do
        @daijobu.expects(:[]=).with('prefix:key', 'value')
        @proxy['key'] = 'value'
      end
    end
    
    describe "method_missing" do
      it "should return a new proxy with compounded namespace" do
        new_proxy = @proxy.another_prefix
        new_proxy.should be_an_instance_of(Daijobu::NamespaceProxy)
        new_proxy.instance_variable_get(:@namespace).should == 'prefix:another_prefix'
      end
    end
  end
end
