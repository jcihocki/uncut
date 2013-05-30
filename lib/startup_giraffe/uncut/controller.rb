module StartupGiraffe
  module Uncut
    module Controller
      def self.included base
        Rails.application.routes.draw do
          match( "/processed_images/:img_protocol/:img_host/:img_path" => "application#cut_image",
                        :via => :get,
                        :constraints => {
                            :host => /[^\/]+/,
                            :path => /.*/
                        }
          )
        end
      end

      def cut_image
        @img = StartupGiraffe::Uncut::Image.new( params[:img_host], params[:img_path], params[:style], params[:img_protocol] )
      end
    end
  end
end
