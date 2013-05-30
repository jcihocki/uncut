module StartupGiraffe
  module Uncut
    class Controller < ApplicationController
      def self.register_routes routing
        routing.match( "/processed_images/:img_protocol/:img_host/:img_path" => "startup_giraffe/uncut/controller#cut_image",
                      :via => :get,
                      :constraints => {
                          :host => /[^\/]+/,
                          :path => /.*/
                      }
        )
      end

      def cut_image
        @img = StartupGiraffe::Uncut::Image.new( params[:img_host], params[:img_path], params[:style], params[:img_protocol] )
      end
    end
  end
end
