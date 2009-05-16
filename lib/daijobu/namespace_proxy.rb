module Daijobu
  class NamespaceProxy
    
    @@default_separator = ':'
    def self.default_separator
      @@default_separator
    end
    
    def self.default_separator=(separator)
      @@default_separator = separator
    end
    
    def initialize(owner, namespace, separator = @@default_separator)
      @owner = owner
      @namespace = namespace.to_s
      @separator = separator
    end
    
    def [](key)
      @owner["#{@namespace}#{@separator}#{key}"]
    end
    
    def []=(key, value)
      @owner["#{@namespace}#{@separator}#{key}"] = value
    end
    
    def method_missing(namespace, *args)
      separator = args.shift || @@default_separator
      Daijobu::NamespaceProxy.new(@owner, "#{@namespace}#{@separator}#{namespace}", separator)
    end
  end
end