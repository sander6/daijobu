$:.unshift(File.dirname(__FILE__))
require 'daijobu/errors'
require 'daijobu/client'
require 'daijobu/parser'
require 'daijobu/scheme_set'
require 'daijobu/adapter'
require 'daijobu/adapters/mem_cache'
require 'daijobu/adapters/tokyo_cabinet'
require 'daijobu/adapters/tokyo_tyrant'