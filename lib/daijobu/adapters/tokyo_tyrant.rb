module Daijobu
  
  module Adapter
    
    # Daijobu::Adapter::TokyoTyrantAdapter wraps getting and setting to a Rufus::Tokyo::Tyrant store.
    class TokyoTyrantAdapter
      
      # Daijobu::Adapter::TokyoTyrantAdapter.new takes a Rufus::Tokyo::Tyrant object.
      def initialize(store)
        @store = store
      end
      
      # Gets the key or keys given, using Tyrant#[] or Tyrant#lget.
      # Multiple values should be returned in a hash, but that's really up to Tyrant object.
      def get(*keys)
        if keys.size == 0
          nil
        elsif keys.size == 1
          @store[keys.first]
        else
          @store.lget(keys)
        end
      end
      
      # Sets the key to the given value (using Tyrant#[]=).
      def set(key, value)
        @store[key] = value
      end
      
    end
    
  end
  
end