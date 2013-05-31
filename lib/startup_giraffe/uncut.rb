require 'net/http'
require 'uri'
require 'hmac-sha1'

require 'startup_giraffe/uncut/image'
if defined?(::Rails)
  require 'startup_giraffe/uncut/controller'
  require 'startup_giraffe/uncut/helper'
end