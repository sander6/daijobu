module Daijobu
  
  # A SchemeSet holds a bundle of schemes, and has logic for iterating over them.
  class SchemeSet
    
    DEFAULT = [ :marshal, :json, :yaml, :eval ]
    
    attr_reader :current

    # SchemeSet.new takes a single symbol or array of symbols and initializes a new Parser
    # object of the appropriate type for each one.
    def initialize(schemes = nil)
      @schemes = []
      schemes = Array(schemes)
      schemes = DEFAULT if schemes.empty?
      schemes.each do |scheme|
        @schemes << (scheme.is_a?(Daijobu::Parser) ? scheme : Daijobu::Parser.get(scheme))
      end
      @current = 0
    end
  
    # Returns the next scheme object in the stack. Raises Daijobu::NoFallbackScheme when there
    # are no more schemes.
    #
    # And yes, I know it's kind of weird to call this method #next when the first invocation
    # returns the first scheme, but it made sense at the time.
    def next
      scheme = @schemes[@current]
      raise NoFallbackScheme unless scheme
      @current += 1
      return scheme
    end
  
    # Resets the stack of schemes, so that the next invocation of #next returns the first scheme
    # (I know, I know).
    def reset
      @current = 0
    end

    # Tries to parse (load) the string with each scheme in turn.
    # Assumes (defensibly) that parsing failed if any non Daijobu::Error exceptions are raised
    # and moves on to the next scheme.
    def parse(str)
      begin
        obj = self.next.parse(str)
      rescue => e
        if e.kind_of?(Daijobu::Error)
          raise e
        else
          obj = parse(str)
        end
      end
      self.reset
      obj
    end
    
    # Tries to unparse (dump) the object with each scheme in turn.
    # Assumes (defensibly) that unparsing failed if any non Daijobu::Error exceptions are raised
    # and moves on to the next scheme.    
    def unparse(obj)
      begin
        str = self.next.unparse(obj)
      rescue => e
        if e.kind_of?(Daijobu::Error)
          raise e
        else
          str = unparse(str)
        end
      end
      self.reset
      str
    end
  end
end