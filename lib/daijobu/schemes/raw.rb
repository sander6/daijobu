module Daijobu
  module Scheme
    
    # Daijobu::Scheme::Raw is the serialization for nothing. Seriously, it doesn't do anything.
    # It's rather dubious why you'd use this scheme for reading (if you're just going to be reading
    # as raw, why use this gem at all?), but writing raw is useful sometimes.
    class Raw

      # Doesn't parse anything. Just returns the string.
      def parse(str)
        str
      end
      
      # Doesn't unparse anything. Just returns the object.
      def unparse(obj)
        obj
      end
      
    end
  end
end
