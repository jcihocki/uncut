module StartupGiraffe
  module Uncut
    module Helper
      def processed_image_uri_for image_uri, style
        parsed_uri = URI.parse( image_uri )
        processed_image_url( img_protocol: parsed_uri.protocol, img_host: parsed_uri.host, img_path: image_uri.request_uri, style: style )
      end
    end
  end
end