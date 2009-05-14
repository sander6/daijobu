module Daijobu
  
  module Adapter
    
    class MemCacheAdapter
      
      def initialize(store)
        @store = store
      end
      
      def get(key)
        @store.get(key, true)
      end
      
      def set(key, value)
        @store.set(key, value, 0, true)
      end
      
    end
    
  end
  
end