$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "rspec"
require "startup_giraffe/uncut"
require "uri"
require "rmagick"

RSpec.configure do |config|
  config.order = "random"
end


