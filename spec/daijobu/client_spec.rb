require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Daijobu::Client do
  
  before do
    @casket = Rufus::Tokyo::Cabinet.new # not a real Rufus::Tokyo::Cabinet. See spec_helper.
  end
  
  describe "initialization" do
    
    it "should set the adapter based on the casket object given" do
      Daijobu::Adapter.expects(:get).with(@casket)
      Daijobu::Client.new(@casket)
    end
    
    it "should set the read and write schemes based on the :schemes scheme list given" do
      Daijobu::SchemeSet.expects(:new).with([:json, :yaml]).twice
      Daijobu::Client.new(@casket, :schemes => [:json, :yaml])
    end
    
    it "should set the read schemes based on the :read scheme list given" do
      Daijobu::SchemeSet.expects(:new).with([:json, :yaml]).once
      Daijobu::SchemeSet.expects(:new).with(nil).once
      Daijobu::Client.new(@casket, :read => [:json, :yaml])
    end
    
    it "should set the write schemes based on the :write scheme list given" do
      Daijobu::SchemeSet.expects(:new).with(nil).once
      Daijobu::SchemeSet.expects(:new).with([:json, :yaml]).once
      Daijobu::Client.new(@casket, :write => [:json, :yaml])
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
      
      describe " #[]" do            
        it "should call #get on the adapter" do
          @adapter.expects(:get).with('key')
          @daijobu['key']
        end
        
        it "should be indifferent to strings and symbols" do
          @adapter.expects(:get).with('key')
          @daijobu[:key]
        end
        
        it "should be indifferent to integers or strings" do
          @adapter.expects(:get).with('123')
          @daijobu[123]
        end
        
        it "should allow you to get multiple keys at once" do
          @adapter.expects(:get).with('key1', 'key2', 'key3')
          @daijobu['key1', 'key2', 'key3']
        end
      end

      describe " #[]=" do
        before do
          @daijobu.stubs(:__unparse__).returns(@stringy)
        end
        
        it "should call set on the adapter" do
          @adapter.expects(:set).with('key', @stringy)
          @daijobu['key'] = @stringy
        end

        it "should be indifferent to strings and symbols" do
          @adapter.expects(:set).with('key', @stringy)
          @daijobu[:key] = @stringy
        end
      end
    end
    

    describe "for parsing and unparsing" do
      before do
        @read_schemes   = @daijobu.instance_variable_get(:@read_schemes)
        @write_schemes  = @daijobu.instance_variable_get(:@write_schemes)
        @stringy        = "woohoo!"
      end
      
      describe " #__parse__" do
        it "should call parse on the read schemes" do
          @read_schemes.expects(:parse).with(@stringy)
          @daijobu.__send__(:__parse__, @stringy)
        end
      end
    
      describe " #__unparse__" do
        it "should call unparse on the write schemes" do
          @write_schemes.expects(:unparse).with(@stringy)
          @daijobu.__send__(:__unparse__, @stringy)
        end
      end
    end
    
    describe "method_missing" do
      
      describe "with no arguments" do
        it "should return a namespace proxy with namespace as the missing method" do
          proxy = @daijobu.prefix
          proxy.should be_an_instance_of(Daijobu::NamespaceProxy)
          proxy.instance_variable_get(:@namespace).should == 'prefix'
        end
      end
      
      describe "with arguments" do
        it "should call #[] on the proxy with the arguments" do
          proxy = stub('fake-daijobu-proxy!')
          Daijobu::NamespaceProxy.expects(:new).with(@daijobu, :prefix).returns(proxy)
          proxy.expects(:[]).with('key')
          @daijobu.prefix('key')
        end
      end
    end
  end
  
end