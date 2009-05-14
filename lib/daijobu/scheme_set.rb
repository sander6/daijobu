module Daijobu
  class SchemeSet
    
    DEFAULT = [ :marshal, :json, :yaml, :eval ]
    
    attr_reader :current
    
    def initialize(*schemes)
      @schemes = (schemes.empty? ? DEFAULT : schemes).collect { |scheme| Daijobu::Scheme.get(scheme) }
      @current = 0
    end
  
    def next
      scheme = @schemes[@current]
      raise NoFallbackScheme unless scheme
      @current += 1
      return scheme
    end
  
    def reset
      @current = 0
    end

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