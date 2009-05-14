module Daijobu
  
  class Error < StandardError; end

  class UnknownScheme < Daijobu::Error; end

  class InvalidAdapter < Daijobu::Error; end
  
  class NoFallbackScheme < Daijobu::Error; end
  
end