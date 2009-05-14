module Daijobu
  module Scheme
    
    def self.get(name)
      case name
      when :marshal
        Daijobu::Scheme::Marshal.new
      when :json
        Daijobu::Scheme::JSON.new
      when :yaml
        Daijobu::Scheme::YAML.new
      when :eval
        Daijobu::Scheme::Eval.new
      else
        raise Daijobu::UnknownScheme
      end
    end
    
  end
end