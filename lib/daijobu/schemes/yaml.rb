require 'yaml'

module Daijobu
  module Scheme
    class YAML
      
      def parse(str)
        str.nil? ? nil : ::YAML.load(str)
      end
      
      def unparse(obj)
        ::YAML.dump(obj)
      end
      
    end
  end
end