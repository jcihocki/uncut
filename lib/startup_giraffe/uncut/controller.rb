module StartupGiraffe
  module Uncut
    module Controller
      def self.included base
        base.send( :extend, ClassMethods )
      end

      module ClassMethods
        def uncut_routes routing
          routing.match( "/processed_images(/:img_protocol(/:img_host(/:img_path)))" => "application#cut_image",
                        :via => :get,
                        :as => :processed_image,
                        :constraints => {
                            :img_host => /[^\/]+/,
                            :img_path => /.+/
                        },
                        :format => false
          )
        end
      end

      def cut_image
        @img = StartupGiraffe::Uncut::Image.new( params[:img_host], params[:img_path], params[:style], params[:img_protocol] )
        @img.download_and_process
        render :text => File.read( @img.file_name ), :content_type => @img.mime_type
      end
    end
  end
end
