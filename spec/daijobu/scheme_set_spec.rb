require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Daijobu::SchemeSet do
  
  describe "initialization" do
    before do
      @scheme_set = Daijobu::SchemeSet.new
    end
    
    it "should set current to 0" do
      @scheme_set.current.should == 0
    end
    
    it "should have the default set of schemes" do
      schemes = @scheme_set.instance_variable_get(:@schemes)
      schemes[0].should be_an_instance_of(Daijobu::Scheme::Marshal)
      schemes[1].should be_an_instance_of(Daijobu::Scheme::JSON)
      schemes[2].should be_an_instance_of(Daijobu::Scheme::YAML)
      schemes[3].should be_an_instance_of(Daijobu::Scheme::Eval)
    end
    
    it "should accept an array of schemes" do
      lambda { Daijobu::SchemeSet.new([:json, :yaml]) }.should_not raise_error
    end
    
    it "should accept a single scheme" do
      lambda { Daijobu::SchemeSet.new(:json) }.should_not raise_error
    end
  end

  describe "initialization with a specified scheme pattern" do
    before do
      @scheme_set = Daijobu::SchemeSet.new([:eval, :yaml])
    end
    
    it "should have the proper schemes in the given order" do
      schemes = @scheme_set.instance_variable_get(:@schemes)
      schemes[0].should be_an_instance_of(Daijobu::Scheme::Eval)
      schemes[1].should be_an_instance_of(Daijobu::Scheme::YAML)      
    end
  end
  
  describe "#next" do
    before do
      @scheme_set = Daijobu::SchemeSet.new
      @schemes    = @scheme_set.instance_variable_get(:@schemes)
    end
    
    it "should return the first of the schemes if #next hasn't been called since the last reset" do
      @scheme_set.next.should == @schemes[0]
    end
    
    it "should advance @current by 1" do
      old = @scheme_set.current
      @scheme_set.next
      @scheme_set.current.should == old + 1
    end
    
    it "should return the next of the schemes on each subsequent calling" do
      @scheme_set.next.should == @schemes[0]
      @scheme_set.next.should == @schemes[1]
      @scheme_set.next.should == @schemes[2]
      @scheme_set.next.should == @schemes[3]
    end
    
    it "should raise an error when there are no schemes left to try" do
      lambda { (@schemes.size + 1).times { @scheme_set.next } }.should raise_error(Daijobu::NoFallbackScheme)      
    end
  end
  
  describe "#reset" do
    before do
      @scheme_set   = Daijobu::SchemeSet.new
      @schemes      = @scheme_set.instance_variable_get(:@schemes)
      @first_scheme = @scheme_set.next
      @scheme_set.current.should_not == 0
    end
    
    it "should reset current to 0" do
      @scheme_set.reset
      @scheme_set.current.should == 0
    end
    
    it "should then make the next subsequent calling of #next return the first scheme" do
      @scheme_set.reset
      @scheme_set.next.should == @first_scheme
    end
  end
  
  describe "#parse" do
    before do
      @scheme_set = Daijobu::SchemeSet.new([:json])
      @stringy    = '{ "thing" : 10 }'
      @hashy      = { "thing" => 10 }
    end

    describe "assuming that the string can be parsed" do
      before do
        Daijobu::Scheme::JSON.any_instance.stubs(:parse).returns(@hashy)
      end
      
      it "should reset" do
        @scheme_set.expects(:reset)
        @scheme_set.parse(@stringy)
      end
      
      it "should return the parsed entity" do
        @scheme_set.parse(@stringy).should == @hashy
      end
    end
    
    describe "assuming that the string can't be parsed" do
      before do
        Daijobu::Scheme::JSON.any_instance.stubs(:parse).raises(Daijobu::Error)
      end
      
      it "should raise the given error" do
        lambda { @scheme_set.parse(@stringy) }.should raise_error(Daijobu::Error)
      end
    end
  end
  
  describe "#parse, when the first (or any earlier) scheme doesn't work" do
    before do
      @stringy    = '{ "thing" : 10 }'
      @hashy      = { "thing" => 10 }

      @scheme_set     = Daijobu::SchemeSet.new([:marshal, :yaml, :json])
      @schemes        = @scheme_set.instance_variable_get(:@schemes)
      @marshal_scheme = @schemes[0]
      @yaml_scheme    = @schemes[1]
      @json_scheme    = @schemes[2]
    end
    
    it "should keep trying to parse with subsequent schemes" do
      @marshal_scheme.expects(:parse).raises(TypeError)
      @yaml_scheme.expects(:parse).raises(ArgumentError)
      @json_scheme.expects(:parse).returns(@stringy)

      @scheme_set.parse(@stringy)
    end
  end
  
  describe "#unparse" do
    before do
      @scheme_set = Daijobu::SchemeSet.new([:json])
      @stringy    = '{ "thing" : 10 }'
      @hashy      = { "thing" => 10 }
    end

    describe "assuming that the object can be unparsed" do
      before do
        Daijobu::Scheme::JSON.any_instance.stubs(:unparse).returns(@stringy)
      end
      
      it "should return the unparsed entity" do
        @scheme_set.unparse(@hashy).should == @stringy
      end
      
      it "should reset" do
        @scheme_set.expects(:reset)
        @scheme_set.unparse(@hashy)
      end
    end
    
    describe "assuming that the object can't be unparsed" do
      before do
        Daijobu::Scheme::JSON.any_instance.stubs(:unparse).raises(Daijobu::Error)
      end
      
      it "should raise the given error" do
        lambda { @scheme_set.unparse(@hashy) }.should raise_error(Daijobu::Error)
      end
    end
  end

  describe "#unparse, when the first (or any earlier) scheme doesn't work" do
    before do
      @stringy    = '{ "thing" : 10 }'
      @hashy      = { "thing" => 10 }

      @scheme_set     = Daijobu::SchemeSet.new([:marshal, :yaml, :json])
      @schemes        = @scheme_set.instance_variable_get(:@schemes)
      @marshal_scheme = @schemes[0]
      @yaml_scheme    = @schemes[1]
      @json_scheme    = @schemes[2]
    end
    
    it "should keep trying to unparse with subsequent schemes" do
      @marshal_scheme.expects(:unparse).raises(TypeError)
      @yaml_scheme.expects(:unparse).raises(ArgumentError)
      @json_scheme.expects(:unparse).returns(@stringy)

      @scheme_set.unparse(@hashy)
    end
  end
end