module Daijobu
  
  module Adapter
    
    # Daijobu::Adapter::TokyoCabinetAdapter wraps getting and setting to a Rufus::Tokyo::Cabinet store.
    class TokyoCabinetAdapter
      
      # Daijobu::Adapter::TokyoCabinetAdapter.new takes a Rufus::Tokyo::Cabinet object.
      def initialize(store)
        @store = store
      end
      
      # Gets the key or keys given, using Cabinet#[] or Cabinet#lget.
      # Multiple values should be returned in a hash, but that's really up to the Cabinet object.
      def get(*keys)
        if keys.size == 0
          nil
        elsif keys.size == 1
          @store[keys.first]
        else
          @store.lget(keys)
        end
      end
      
      # Sets the key to the given value (using Cabinet#[]=).
      def set(key, value)
        @store[key] = value
      end
      
    end
    
  end
  
end