module Daijobu
  
  module Adapter
    
    class TokyoTyrantAdapter
      
      def initialize(store)
        @store = store
      end
      
      def get(*keys)
        if keys.size == 0
          nil
        elsif keys.size == 1
          @store[keys.first]
        else
          @store.lget(keys)
        end
      end
      
      def set(key, value)
        @store[key] = value
      end
      
    end
    
  end
  
end