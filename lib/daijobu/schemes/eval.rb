module Daijobu
  module Scheme
    
    # Daijobu::Scheme::Eval is the serialization for pure Ruby code.
    # Theoretically, then, anything could be put into and taken out of a key-value-store,
    # provided that they're always rehydrated into an appropriate binding.
    class Eval
      
      # Parses by #eval'ing the string.
      def parse(str)
        str.nil? ? nil : eval(str)
      end
      
      # Unparses by #inspect'ing the object. 
      def unparse(obj)
        obj.inspect
      end
      
    end
  end
end