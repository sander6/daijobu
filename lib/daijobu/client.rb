module Daijobu
  
  # The unfortunately-named Daijobu::Client is the serialization wrapper for key-value stores.
  class Client

    @@default_separator = ':'
    
    # Getter for the default separator. Default is ':'
    def self.default_separator
      @@default_separator
    end
    
    # Setter for the default separator. I use ':', but a lot of people like '/'.
    def self.default_separator=(separator)
      @@default_separator = separator
    end

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
      @namespace      = nil
      @separator      = nil
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

    # Any missing method is assumed to be a namespace for keys to get. Returns self, so
    # namespaces can be chained together.
    #
    #     client.namespace['key']             # => gets key 'namespace:key'
    #     client.name.space['key']            # => gets key 'name:space:key'
    #     client.namespace['key'] = 'value'   # => sets key 'namespace:key'
    #
    # If you have mixed separators in your keys, or don't want to fiddle around with the
    # class-level default_separator, you can pass the separator to use as an argument to
    # any missing method.
    #
    #     client.name('/').space('-')['key']  # => gets key 'name/space-key'
    #
    # The last separator mentioned will be use for subsequent separating.
    #
    #     client.some('/').really(':').long.name('-').space['key'] # => gets key 'some/really:long:name-space-key'
    def method_missing(namespace, separator = nil, *args, &block)
      @namespace = "#{@namespace}#{@separator}#{namespace}"
      @separator = separator || @separator || @@default_separator
      self
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