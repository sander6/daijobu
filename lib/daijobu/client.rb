module Daijobu
  class Client

    def initialize(casket, *schemes)
      @adapter      = Daijobu::Adapter.get(casket)
      @schemes      = Daijobu::SchemeSet.new(*schemes)
    end

    def [](key)
      parse(@adapter.get(key))
    end

    def []=(key, value)
      @adapter.set(key, unparse(value))
    end

    private

    def parse(str)
      @schemes.parse(str)
    end

    def unparse(obj)
      @schemes.unparse(obj)
    end

  end
end