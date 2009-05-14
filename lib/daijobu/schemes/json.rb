require 'json'

module Daijobu
  module Scheme
    class JSON
      
      def parse(str)
        str.nil? ? nil : ::JSON.parse(str)
      end
      
      def unparse(obj)
        ::JSON.unparse(obj)
      end
      
    end
  end
end