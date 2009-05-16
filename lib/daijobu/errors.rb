module Daijobu
  
  # The superclass of all the errors that Daijobu raises.
  class Error < StandardError; end

  # Raised when asking for a scheme that doesn't exist.
  # Supported schemes are :marshal, :json, :yaml, :eval, and :raw.
  class UnknownScheme < Daijobu::Error; end

  # Raised when the key-value-store object doesn't have a appropriate adapter.
  # Supported stores are MemCache, Rufus::Tokyo::Cabinet, and Rufus::Tokyo::Tyrant.
  class InvalidAdapter < Daijobu::Error; end
  
  # Raised when all of the (un)parsing schemes fail.
  class NoFallbackScheme < Daijobu::Error; end
  
end