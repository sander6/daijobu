module Daijobu
  
  module Adapter
    
    # Daijobu::Adapter::MemCacheAdapter wraps getting and setting to a MemCache store.
    # Note that you can use MemCache to talk to a Tokyo Tyrant server, since they
    # speak the same language.
    class MemCacheAdapter
      
      # Daijobu::Adapter::MemCacheAdapter.new takes a MemCache object.
      def initialize(store)
        @store = store
      end
      
      # Gets the key or keys given. Multiple values will be returned in a hash.
      def get(*keys)
        if keys.size == 0
          nil
        elsif keys.size == 1
          get_one(keys.first)
        else
          keys.inject({}) { |agg, key| agg.merge(key => get_one(key)) } 
        end
      end
      
      # Sets the key to the given value (using MemCache#add).
      def set(key, value)
        @store.add(key, value, 0, true)
      end
      
      private
      
      # Gets a single key. Used internally.
      def get_one(key)
        @store.get(key, true)
      end
      
    end
    
  end
  
end