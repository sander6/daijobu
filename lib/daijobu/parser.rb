module Daijobu
  
  # A Daijobu::Parser handles serialization and deserialization of strings and objects.
  # It can either send methods to a delegate object that serializes (for example, the
  # Marshal modules), or define its own schemes.
  class Parser

    # Returns a new Parser from a fixed default set designed to handle the most common
    # serialization schemes. Pass the name of the Parser you want as a symbol.
    #
    #     :marshal  => a parser for Ruby binary format, using the Marshal module
    #     :json     => a parser for JSON, using the JSON module (requires the json gem)
    #     :yaml     => a parser for YAML, using the YAML module
    #     :eval     => a parser for Ruby code, using #eval and #inspect
    #     :raw      => a parser for raw strings that doesn't actually do anything
    def self.get(name)
      respond_to?(name) ? __send__(name) : raise(UnknownScheme)
    end
    
    # Returns a new Parser for serializing Ruby binary.
    #
    #     :parse    => Marshal.load(string)
    #     :unparse  => Marshal.dump(object)
    def self.marshal
      new(Marshal, :parse => :load, :unparse => :dump)
    end
    
    # Returns a new Parser for serializing JSON.
    #
    #     :parse    => JSON.parse(string)
    #     :unparse  => JSON.unparse(object)    
    def self.json
      require 'json'
      new(JSON, :parse => :parse, :unparse => :unparse)
    end
    
    # Returns a new Parser for serializing YAML.
    #
    #     :parse    => YAML.load(string)
    #     :unparse  => YAML.dump(object)
    def self.yaml
      require 'yaml'
      new(YAML, :parse => :load, :unparse => :dump)
    end
    
    # Returns a new Parser for serializing Ruby code.
    #
    #     :parse    => Kernel.eval(string)
    #     :unparse  => object.inspect
    def self.eval
      new(:parse => Proc.new { |str| Kernel::eval(str) }, :unparse => Proc.new { |obj| obj.inspect })
    end
    
    # Returns a new Parser that does nothing.
    #
    #     :parse    => string
    #     :unparse  => object
    def self.raw
      new(:parse => Proc.new { |str| str }, :unparse => Proc.new { |obj| obj })
    end
    
    # Takes a delegate object an a hash specifying which methods of the delegate should be used for
    # parsing and unparsing. For example, say there was some module called Parsley that had methods
    # #load and #dump for deserialization and serialization, respectively. To make a new parser
    # using Parsley, you would say
    #
    #     parser = Daijobu::Parser.new(Parsely, :parse => :load, :unparse => :dump)
    #
    # Alternately, you can pass procs as the parse and unparse keys. The parse proc should accept a
    # String, and the unparse proc should accept any Object. For fallback schemes to work, these procs
    # should raise any error (except a Daijobu::Error) if they fail in any way. This isn't strictly
    # necessary if you're only using one serialization scheme.
    #
    #     parser = Daijobu::Parser.new({
    #       :parse    => Proc.new { |string| string.do_something_fancy },
    #       :unparse  => Proc.new { |object| object.undo_something_fancy }
    #     })
    # 
    # Or, if you don't like passing procs as keyword arguments (I sure don't), you can give a block
    # and define the parse and unparse methods (and technically anything else you want) on the
    # parser object directly.
    #
    #     parser = Daijobu::Parser.new do
    #       def parse(string)
    #         raise SomeKindOfError unless string.passes_some_conditions?
    #         string.turn_into_an_object_somehow
    #       end
    #       def uparse(object)
    #         raise ADifferentKindOfError unless object.can_be_dumped?
    #         object.dump_to_string_using_some_clever_method
    #       end
    #     end
    def initialize(*args, &block)
      strategies        = args.last.is_a?(Hash) ? args.pop : {}
      @delegate         = args.shift
      @parse_strategy   = strategies[:parse]
      @unparse_strategy = strategies[:unparse]
      (class << self; self; end).class_eval(&block) if block_given?
    end

    # Parses the string. Parsing nil always returns nil.
    def parse(str)
      str.nil? ? nil : strategize(@parse_strategy, str)
    end
    
    # Unparses the object.
    def unparse(obj)
      strategize(@unparse_strategy, obj)
    end
    
    private
    
    # Either sends the symbol to the delegate, or calls the proc for the given strategy.
    def strategize(strategy, arg)
      case strategy
      when Symbol
        raise MissingDelegate unless @delegate
        @delegate.__send__(strategy, arg)
      when Proc
        strategy.call(arg)
      else
        raise InvalidStrategy
      end
    end
  end
end