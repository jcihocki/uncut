module StartupGiraffe
  module Uncut
    module Helper
      def processed_image_uri_for image_uri, style = ""
        parsed_uri = URI.parse( image_uri )
        path = parsed_uri.request_uri
        path.slice!(0,1)
        processed_image_path(
            img_protocol: parsed_uri.scheme,
            img_host: parsed_uri.host,
            img_path: path.split( "/" ).collect { |seg| URI.encode_www_form_component( seg ) }.join( "/" ),
            style: style
        )
      end
    end
  end
end