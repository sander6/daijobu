module Daijobu
  
  # The unfortunately-named Daijobu::Client is the serialization wrapper for key-value stores.
  class Client

    # Client.new takes a key-value store as its first argument, and then a hash of serialization schemes.
    #
    # Options:
    #   :schemes  => the scheme or schemes used to read and write, in order
    #   :read     => the scheme or schemes used to read, in order. Trumped by :schemes
    #   :write    => the scheme or schemes used to write, in order. Trumped by :schemes
    def initialize(casket, options = {})
      @adapter        = Daijobu::Adapter.get(casket)
      @read_schemes   = Daijobu::SchemeSet.new(options[:schemes] || options[:read])
      @write_schemes  = Daijobu::SchemeSet.new(options[:schemes] || options[:write])
    end

    # Getter for keys. The actual getting method is handled by the specific Adapter object.
    # You can ask for multiple keys at once, in which case this returns a hash of key => value.
    def [](*keys)
      __parse__(@adapter.get(*keys.collect { |key| key.to_s }))
    end

    # Setter for keys. The actual setting method is handled by the specific Adapter object.
    def []=(key, value)
      @adapter.set(key.to_s, __unparse__(value))
    end

    # Any missing method is assumed to be a namespace for keys to get. The NamespaceProxy object
    # returned also implements the same kind of method_missing, so namespaces can be chained together.
    #
    #     client.namespace['key']           # => gets key 'namespace:key'
    #     client.name.space['key']          # => gets key 'name:space:key'
    #     client.namespace['key'] = 'value' # => sets key 'namespace:key'
    #
    # As an added bit of syntactic sugar, you can leave the brackets off when getting keys this way.
    #
    #     client.namespace 'key' # => same as client.namespace['key']
    #
    # See NamespaceProxy for more details about setting the separator.
    def method_missing(name, *args)
      args.empty? ? Daijobu::NamespaceProxy.new(self, name) : Daijobu::NamespaceProxy.new(self, name)[*args]
    end

    private

    # Tries to parse (load) the string using each of the reading schemes in order.
    # The actual parsing is done by the specific Scheme object.
    def __parse__(str)
      @read_schemes.parse(str)
    end

    # Tries to unparse (dump) the object using each of the writing schemes in order.
    # The actual unparsing is done by the specific Scheme object.
    def __unparse__(obj)
      @write_schemes.unparse(obj)
    end

  end
end