module Daijobu
  
  module Adapter
    
    class MemCacheAdapter
      
      def initialize(store)
        @store = store
      end
      
      def get(*keys)
        if keys.size == 0
          nil
        elsif keys.size == 1
          get_one(keys.first)
        else
          keys.inject({}) { |agg, key| agg.merge(key => get_one(key)) } 
        end
      end
      
      def set(key, value)
        @store.add(key, value, 0, true)
      end
      
      private
      
      def get_one(key)
        @store.get(key, true)
      end
      
    end
    
  end
  
end