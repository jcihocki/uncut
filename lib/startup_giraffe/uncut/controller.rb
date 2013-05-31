module StartupGiraffe
  module Uncut
    module Controller
      def self.included base
        base.send( :extend, ClassMethods )
        class << base
          attr_accessor :cache_control
        end
        base.cache_control = "public, max-age=#{1.year.to_i}"
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
        begin
          @img = StartupGiraffe::Uncut::Image.new( params[:img_host], params[:img_path], params[:style], params[:img_protocol] )
          @img.download_and_process
          response.headers["Cache-Control"] = self.class.cache_control
          response.headers["Expires"] = 1.year.from_now.httpdate
          render :text => @img.data, :content_type => @img.mime_type
        rescue StartupGiraffe::Uncut::ImageDownloadError
          Rails.logger.debug( $!.message )
          head :not_found
        end
      end
    end
  end
end
