module Daijobu
  module Adapter
    
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