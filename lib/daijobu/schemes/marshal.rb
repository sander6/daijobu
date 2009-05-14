module Daijobu
  module Scheme
    class Marshal
      
      def parse(str)
        str.nil? ? nil : ::Marshal.load(str)
      end
      
      def unparse(obj)
        ::Marshal.dump(obj)
      end
      
    end
  end
end