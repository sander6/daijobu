module Daijobu
  class Parser

    def self.get(name)
      respond_to?(name) ? __send__(name) : raise(UnknownScheme)
    end
    
    def self.marshal
      new(Marshal, :parse => :load, :unparse => :dump)
    end
    
    def self.json
      require 'json'
      new(JSON, :parse => :parse, :unparse => :unparse)
    end
    
    def self.yaml
      require 'yaml'
      new(YAML, :parse => :load, :unparse => :dump)
    end
    
    def self.eval
      new(:parse => Proc.new { |str| Kernel::eval(str) }, :unparse => Proc.new { |obj| obj.inspect })
    end
    
    def self.raw
      new(:parse => Proc.new { |str| str }, :unparse => Proc.new { |obj| obj })
    end
    
    def initialize(*args, &block)
      options           = args.last.is_a?(Hash) ? args[-1] : {}
      @delegate         = args.size == 1 ? nil : args[0]
      @parse_strategy   = options[:parse]
      @unparse_strategy = options[:unparse]
      (class << self; self; end).class_eval(&block) if block_given?
    end
    
    def parse(str)
      str.nil? ? nil : strategize(@parse_strategy, str)
    end
    
    def unparse(obj)
      strategize(@unparse_strategy, obj)
    end
    
    private
    
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