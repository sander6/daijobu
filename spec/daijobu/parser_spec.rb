require File.dirname(__FILE__) + '/../spec_helper'

describe Daijobu::Parser do
  
  before do
    @string = '{ "serialized" : "structure" }'
    @object = Object.new
  end
  
  describe ".get" do
    it "should return a Daijobu::Parser object" do
      Daijobu::Parser.get(:marshal).should be_an_instance_of(Daijobu::Parser)
    end
    
    it "should raise an error when passed a name it doesn't know about" do
      lambda { Daijobu::Parser.get(:buckwild) }.should raise_error(Daijobu::UnknownScheme)
    end
    
    it "should send the given name as a method to itself" do
      Daijobu::Parser.stubs(:respond_to?).returns(true)
      Daijobu::Parser.expects(:buckwild)
      Daijobu::Parser.get(:buckwild)
    end
    
    describe ".marshal" do
      it "should return a new parser that delegates parsing as :load and unparsing as :dump to Marshal" do
        Daijobu::Parser.expects(:new).with(Marshal, { :parse => :load, :unparse => :dump })
        Daijobu::Parser.marshal
      end
    end
    
    describe ".json" do
      it "should return a new parser that delegates parsing as :parse and unparsing as :unparse to JSON" do
        Daijobu::Parser.expects(:new).with(JSON, { :parse => :parse, :unparse => :unparse })
        Daijobu::Parser.json
      end
    end
    
    describe ".yaml" do
      it "should return a new parser that delegates parsing as :load and unparsing as :dump to YAML" do
        Daijobu::Parser.expects(:new).with(YAML, { :parse => :load, :unparse => :dump })
        Daijobu::Parser.yaml
      end
    end
    
    describe ".eval" do
      it "should return a new parser that delegates parsing and unparsing as some procs" do
        Daijobu::Parser.expects(:new).with(instance_of(Hash))
        Daijobu::Parser.eval
      end
      
      describe "should return a parser that" do
        before do
          @parser = Daijobu::Parser.eval
        end

        it "should eval the string given to parse" do
          Kernel.expects(:eval).with(@string)
          @parser.parse(@string)
        end
        
        it "should inspect the object to unparse" do
          @object.expects(:inspect)
          @parser.unparse(@object)
        end
      end
    end
    
    describe ".raw" do
      it "should return a new parser that delegates parsing and unparsing as some procs" do
        Daijobu::Parser.expects(:new).with(instance_of(Hash))
        Daijobu::Parser.raw
      end
      
      describe "should return a parser that" do
        before do
          @parser = Daijobu::Parser.raw
        end
        
        it "should return the string given to parse" do
          @parser.parse(@string).should == @string
        end
        
        it "should return the object given to unparse" do
          @parser.unparse(@object).should == @object
        end
      end
    end
  end
  
  describe "parsing" do
    it "should return nil when trying to parse nil" do
      @parser = Daijobu::Parser.new
      @parser.parse(nil).should be_nil
    end
    
    describe "with a symbol strategy" do
      before do
        @symbol = :load
      end
      
      describe "without a delegate" do
        before do
          @parser = Daijobu::Parser.new(:parse => @symbol)
          @parser.instance_variable_get(:@parse_strategy).should == @symbol
        end
        
        it "should raise an error" do
          lambda { @parser.parse(@string) }.should raise_error(Daijobu::MissingDelegate)
        end
      end
      
      describe "with a delegate" do
        before do
          @delegate = Object.new
          @parser   = Daijobu::Parser.new(@delegate, :parse => @symbol)
        end
        
        it "should send the symbol and the argument to the delegate" do
          @delegate.expects(@symbol).with(@string)
          @parser.parse(@string)
        end
      end
    end
    
    describe "with a proc strategy" do
      before do
        @proc   = Proc.new { |string| string.downcase }
        @parser = Daijobu::Parser.new(:parse => @proc)
      end
      
      it "should call the proc with the argument" do
        @proc.expects(:call).with(@string)
        @parser.parse(@string)
      end
    end
  end
  
  describe "unparsing" do
    describe "with a symbol strategy" do
      before do
        @symbol = :dump
      end
      
      describe "without a delegate" do
        before do
          @parser = Daijobu::Parser.new(:unparse => @symbol)
        end
        
        it "should raise an error" do
          lambda { @parser.unparse(@object) }.should raise_error(Daijobu::MissingDelegate)
        end
      end
      
      describe "with a delegate" do
        before do
          @delegate = Object.new
          @parser   = Daijobu::Parser.new(@delegate, :unparse => @symbol)
        end
        
        it "should send the symbol and the argument to the delegate" do
          @delegate.expects(@symbol).with(@object)
          @parser.unparse(@object)
        end
      end
    end
    
    describe "with a proc strategy" do
      before do
        @proc   = Proc.new { |object| object.inspect }
        @parser = Daijobu::Parser.new(:unparse => @proc)
      end
      
      it "should call the proc with the argument" do
        @proc.expects(:call).with(@string)
        @parser.unparse(@string)
      end
    end
  end
  
  describe "when given a block" do
    before do
      @parser = Daijobu::Parser.new do
        def parse(str)
          eval(str)
        end
        
        def unparse(obj)
          obj.inspect
        end

        def test
          "Make sure this shows up."
        end
      end      
    end
    
    it "should add the defined methods to the parser instance" do
      @parser.should respond_to(:parse)
      @parser.should respond_to(:unparse)
      @parser.should respond_to(:test)
    end
    
    it "should redefine the parse or unparse methods as defined" do
      @parser.expects(:eval).with(@string)
      @parser.parse(@string)
      @object.expects(:inspect)
      @parser.unparse(@object)
    end
  end
end