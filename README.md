=== Uncut: On demand image processing ===

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

and in routes.rb:

`ApplicationController.uncut_routes self`
