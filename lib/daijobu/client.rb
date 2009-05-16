module Daijobu
  class Client

    def initialize(casket, options = {})
      @adapter        = Daijobu::Adapter.get(casket)
      @read_schemes   = Daijobu::SchemeSet.new(options[:schemes] || options[:read])
      @write_schemes  = Daijobu::SchemeSet.new(options[:schemes] || options[:write])
    end

    def [](*keys)
      __parse__(@adapter.get(*keys.collect { |key| key.to_s }))
    end

    def []=(key, value)
      @adapter.set(key.to_s, __unparse__(value))
    end

    def method_missing(name, *args)
      args.empty? ? Daijobu::NamespaceProxy.new(self, name) : Daijobu::NamespaceProxy.new(self, name)[*args]
    end

    private

    def __parse__(str)
      @read_schemes.parse(str)
    end

    def __unparse__(obj)
      @write_schemes.unparse(obj)
    end

  end
end