module Daijobu
  
  module Adapter
    
    class TokyoCabinetAdapter
      
      def initialize(store)
        @store = store
      end
      
      def get(key)
        @store[key]
      end
      
      def set(key, value)
        @store[key] = value
      end
      
    end
    
  end
  
end