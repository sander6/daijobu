require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Daijobu::Adapter do

  describe ".get" do
    
    before do
      Daijobu::Adapter.stubs(:defined?).returns(true)
      @casket = stub("fake casket")
    end
    
    describe "with a MemCache instance" do
      before do
        @casket.stubs(:is_a?).with(MemCache).returns(true)
        @casket.stubs(:is_a?).with(Rufus::Tokyo::Cabinet).returns(false)
        @casket.stubs(:is_a?).with(Rufus::Tokyo::Tyrant).returns(false)
      end

      it "should return a MemCache adapter" do
        Daijobu::Adapter.get(@casket).should be_an_instance_of(Daijobu::Adapter::MemCacheAdapter)
      end
    end
    
    describe "with a Rufus::Tokyo::Cabinet instance" do
      before do
        @casket.stubs(:is_a?).with(MemCache).returns(false)
        @casket.stubs(:is_a?).with(Rufus::Tokyo::Cabinet).returns(true)
        @casket.stubs(:is_a?).with(Rufus::Tokyo::Tyrant).returns(false)
      end

      it "should return a Tokyo Cabinet adapter" do
        Daijobu::Adapter.get(@casket).should be_an_instance_of(Daijobu::Adapter::TokyoCabinetAdapter)
      end
    end
    
    describe "with a Rufus::Tokyo::Tyrant instance" do
      before do
        @casket.stubs(:is_a?).with(MemCache).returns(false)
        @casket.stubs(:is_a?).with(Rufus::Tokyo::Cabinet).returns(false)
        @casket.stubs(:is_a?).with(Rufus::Tokyo::Tyrant).returns(true)
      end

      it "should return a Tokyo Tyrant adapter" do
        Daijobu::Adapter.get(@casket).should be_an_instance_of(Daijobu::Adapter::TokyoTyrantAdapter)
      end      
    end
    
    describe "with anything else" do
      it "should raise an error" do
        lambda { Daijobu::Adapter.get(:bogus) }.should raise_error(Daijobu::InvalidAdapter)
      end
    end
    
  end
  
end