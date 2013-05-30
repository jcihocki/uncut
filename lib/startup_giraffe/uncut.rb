require 'net/http'
require 'uri'
require 'hmac-sha1'

module StartupGiraffe
  module Uncut
    module_function

    def register_routes resource, tmp_dir, routing, secret = nil
      Image.tmp_dir = tmp_dir
    end
  end
end

require 'startup_giraffe/uncut/image'
if defined?(::Rails)
  require 'startup_giraffe/uncut/controller'
  require 'startup_giraffe/uncut/helper'
end