require 'json'

module Daijobu
  module Scheme
    
    # Daijobu::Scheme::JSON is the serialization for JSON.
    # Uses the native (C) json gem, which is respectably fast.
    class JSON
      
      # Parses the string using JSON.parse.
      # JSON is pretty strict, and it dies whenever the object doesn't have an enclosing
      # structure (i.e. an array or tuple). You might have problems parsing bare strings,
      # integers, booleans, and nulls. It's weird, though, because JSON doesn't seem to have
      # a problem unparsing these things. Just a heads-up.
      def parse(str)
        str.nil? ? nil : ::JSON.parse(str)
      end
      
      # Unparses the object using JSON.unparse.
      def unparse(obj)
        ::JSON.unparse(obj)
      end
      
    end
  end
end