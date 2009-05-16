module Daijobu
  
  # Daijobu::Adapter is the parent module of the various adapter classes.
  module Adapter
    
    # Given an object, returns a new instance of the corresponding adapter based on the
    # object's class.
    #
    #   MemCache              => Daijobu::Adapter::MemCacheAdapter
    #   Rufus::Tokyo::Cabinet => Daijobu::Adapter::TokyoCabinetAdapter
    #   Rufus::Tokyo::Tyrant  => Daijobu::Adapter::TokyoTyrantAdapter
    #
    # Raises Daijobu::InvalidAdapter if given a object it doesn't know about.
    def self.get(casket)
      if defined?(MemCache) && casket.is_a?(MemCache)
        Daijobu::Adapter::MemCacheAdapter.new(casket)
      elsif defined?(Rufus::Tokyo::Cabinet) && casket.is_a?(Rufus::Tokyo::Cabinet)
        Daijobu::Adapter::TokyoCabinetAdapter.new(casket)
      elsif defined?(Rufus::Tokyo::Tyrant) && casket.is_a?(Rufus::Tokyo::Tyrant)
        Daijobu::Adapter::TokyoTyrantAdapter.new(casket)
      else
        raise Daijobu::InvalidAdapter
      end
    end
    
  end
end