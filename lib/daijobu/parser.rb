module Daijobu
  class Parser
    
    def initialize(*args, &block)
      strategies        = args.last.is_a?(Hash) ? args.pop : {}
      @delegate         = args.shift
      @parse_strategy   = strategies[:parse]
      @unparse_strategy = strategies[:unparse]
      (class << self; self; end).class_eval(&block) if block_given?
    end
    
    def parse(str)
      strategize(@parse_strategy, str)
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