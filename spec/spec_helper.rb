require 'rubygems'
require 'spec'
require 'mocha'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'daijobu'

# Some fake contants for the classes and stuff referred to.
MemCache              = Class.new unless defined?(MemCache)
Rufus                 = Module.new unless defined?(Rufus)
Rufus::Tokyo          = Module.new unless defined?(Rufus::Tokyo)
Rufus::Tokyo::Cabinet = Class.new unless defined?(Rufus::Tokyo::Cabinet)
Rufus::Tokyo::Tyrant  = Class.new unless defined?(Rufus::Tokyo::Tyrant)

Spec::Runner.configure do |config|
  config.mock_with :mocha
end
