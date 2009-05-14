module Daijobu
  module Scheme
    class Eval
      
      def parse(str)
        str.nil? ? nil : eval(str)
      end
      
      def unparse(obj)
        obj.inspect
      end
      
    end
  end
end