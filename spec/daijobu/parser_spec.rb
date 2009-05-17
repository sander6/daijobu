require File.dirname(__FILE__) + '/../spec_helper'

describe Daijobu::Parser do
  
  before do
    @stucture = '{ "serialized" : "structure" }'
    @object   = Object.new
  end
  
  describe "parsing" do
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