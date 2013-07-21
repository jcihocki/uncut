# Uncut: On demand image processing #

Instead of using paperclip to process your images at upload, you can use uncut to 
lazily proxy and resize your images as they are requested by the browser. This allows 
your app to upload user generated images directly to a file store such as s3 from the 
browser and proxy them later, as necessary.

If your image sizes later change due to redesign, or if you need many different sizes,
it's a nice alternative to having to run large batch reprocessing jobs and using up
a lot of storage on S3.

Easy to configure in your Gemfile:

`gem 'uncut', :git => 'https://github.com/jcihocki/uncut.git', :branch => '1.0'`

in ApplicationController:

`include StartupGiraffe::Uncut::Controller`

in ApplicationHelper:

`include StartupGiraffe::Uncut::Helper`

and in routes.rb:

`ApplicationController.uncut_routes self`


Then to render an img url for a particular geometry:

`<%= image_tag processed_image_uri_for( "http://mybucket.s3.amazonaws.com/path/to/img.jpg", '50x50' )  %>`

#processed_image_uri_for returns a relative path. You should cache the results of the image 
processing at the http level using an external cache such as Cloudfront or varnish. Just 
using rack-cache or something like that may fill up your app's memcached store pretty quickly.  

The style parameter should take any geometry string suitable for use with paperclip/rmagick. Currently
format and quality are not supported but should be easy to add.
