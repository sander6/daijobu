module Daijobu

  # The Scheme module is the parent of the various serialization schemes.
  module Scheme
    
    # Given a name, returns a new instance of the corresponding scheme.
    #
    #   :marshal  => Daijobu::Scheme::Marshal
    #   :json     => Daijobu::Scheme::JSON
    #   :yaml     => Daijobu::Scheme::YAML
    #   :eval     => Daijobu::Scheme::Eval
    #   :raw      => Daijobu::Scheme::Raw
    #
    # Raises Daijobu::UnknownScheme if given a name it can't handle. 
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
      when :raw
        Daijobu::Scheme::Raw.new
      else
        raise Daijobu::UnknownScheme
      end
    end
    
  end
end