module Daijobu
  class NamespaceProxy
    
    @@default_separator = ':'
    
    # Getter for the default separator. Default is ':'
    def self.default_separator
      @@default_separator
    end
    
    # Setter for the default separator. I use ':', but a lot of people like '/'.
    def self.default_separator=(separator)
      @@default_separator = separator
    end

    # NamespaceProxy.new takes an owner (a Daijobu::Client), a namespace, and a separator (defaults 
    # to @@default_separator).
    # NamespaceProxy objects are typically created using Daijobu::Client#method_missing, so you're
    # rarely going to instantiate one of these on your own.
    def initialize(owner, namespace, separator = @@default_separator)
      @owner = owner
      @namespace = namespace.to_s
      @separator = separator
    end

    # Sends #[] back to the owner, prepending the key given with the namespace and separator.
    def [](key)
      @owner["#{@namespace}#{@separator}#{key}"]
    end

    # Sends #[]= back to the owner, prepending the key given with the namespace and separator.    
    def []=(key, value)
      @owner["#{@namespace}#{@separator}#{key}"] = value
    end

    # Any missing method is assumed to be yet another namespace.
    def method_missing(namespace, *args)
      separator = args.shift || @@default_separator
      @namespace = "#{@namespace}#{@separator}#{namespace}"
      @separator = separator
      self
    end
  end
end