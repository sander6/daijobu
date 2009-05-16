module Daijobu
  module Scheme
    
    # Daijobu::Scheme::Marshal is the serialization for Ruby binary code.
    class Marshal
      
      # Parses the string using Marshal.load.
      def parse(str)
        str.nil? ? nil : ::Marshal.load(str)
      end
      
      # Unparses the object using Marshal.dump.
      def unparse(obj)
        ::Marshal.dump(obj)
      end
      
    end
  end
end