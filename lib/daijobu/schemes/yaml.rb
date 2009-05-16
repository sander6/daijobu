require 'yaml'

module Daijobu
  module Scheme
    
    # Daijobu::Scheme::YAML is the serialization for YAML.
    # Due to the strictness of the JSON module, you'll often have more luck parsing JSON containing 
    # bare objects (strings, integers, booleans, etc. without an enclosing structure) using YAML
    # than with JSON, but YAML's a lot slower. That being said, it makes a good fallback scheme to use
    # when JSON starts dying.
    class YAML
      
      # Parses the string using YAML.load.
      def parse(str)
        str.nil? ? nil : ::YAML.load(str)
      end
      
      # Unparses the object using YAML.dump.
      def unparse(obj)
        ::YAML.dump(obj)
      end
      
    end
  end
end