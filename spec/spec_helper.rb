require 'rubygems'
require 'spec'
require 'mocha'
require 'rufus/tokyo'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'daijobu'

Spec::Runner.configure do |config|
  config.mock_with :mocha
end
