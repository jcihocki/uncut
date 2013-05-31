require 'hmac-sha1'
require 'net/http'
require 'uri'
require 'bson'
require 'rmagick'

module StartupGiraffe
  module Uncut
    class ImageDownloadError < StandardError ; end

    class Image
      Paperclip.interpolates( :tmp_dir ) { |attachment, style| attachment.instance.class.tmp_dir }
      Paperclip.interpolates( :uri_hash ) { |attachment, style| attachment.instance.uri_hash }

      extend  ActiveModel::Callbacks
      include ActiveModel::Validations

      include Paperclip::Glue

      define_model_callbacks :save
      define_model_callbacks :destroy

      ENV['TMPDIR'] ||= "/tmp"
      @tmp_dir = ENV['TMPDIR'].gsub( /\/$/, '' )
      @paperclip_path = ":tmp_dir/:uri_hash.:style.image"
      class << self; attr_accessor :tmp_dir, :paperclip_path ; end

      has_attached_file :attachment,
        :styles => Proc.new { |attachment| attachment.instance.styles },
        :path => @paperclip_path

      attr_accessor :uri_hash, :mime_type, :file_name, :data, :attachment_file_name, :attachment_file_size

      def initialize host, path, style, protocol = "http", port = nil
        @host, @path, @dynamic_style_format, @port, @protocol = host, path, style, port, protocol
        @path.slice!(0,1) if @path[0] == "/"
        @uri = URI.parse( "#{@protocol}://#{@host}#{':' + @port if @port}/#{@path}" )
        compute_uri_hash!
      end

      def compute_uri_hash!
        @uri_hash = HMAC::SHA1.hexdigest( "", @uri.to_s )
      end

      def dynamic_style_format_symbol
        URI.escape(@dynamic_style_format).to_sym
      end

      def styles
        unless @dynamic_style_format.blank?
          { dynamic_style_format_symbol => @dynamic_style_format }
        else
          {}
        end
      end

      def id
        BSON::ObjectId.new.to_s
      end

      def as_file

      end

      def as_data

      end

      def download_and_process
        http = Net::HTTP.new( @uri.host, @uri.port )
        http.use_ssl = (@uri.scheme == 'https')
        req = Net::HTTP::Get.new(@uri.request_uri)
        tmp_path = [self.class.tmp_dir, @uri_hash].join( "/" )
        cut_path = self.attachment.send( :interpolate, self.class.paperclip_path, self.dynamic_style_format_symbol )
        if File.exists?( cut_path )
          @mime_type = File.read( "#{tmp_path}.mime" ).strip
          @file_name = cut_path
        else
          begin
            http.request( req ) do |resp|
              if resp.code.to_i == 200
                @mime_type = resp['content-type']
                File.open( "#{tmp_path}.mime", "w" ) do |file|
                  file.write( @mime_type )
                end
                begin
                  rmagick_img = Magick::Image::from_blob( resp.body ).first
                  @data = rmagick_img.change_geometry( @dynamic_style_format ) do |w, h|
                    rmagick_img.resize_to_fill( w, h ).to_blob
                  end
                rescue Magick::ImageMagickError
                  raise ImageDownloadError,  "Content at uri #{@uri.to_s}, couldn't be parsed as an img (Content type was #{resp['content-type']})"
                end
                #File.open( tmp_path, "wb" ) do |file|
                #  resp.read_body do |chunk|
                #    file.write( chunk )
                #  end
                #end
                #
                #File.open( tmp_path, "rb" ) do |file|
                #  self.attachment = file
                #  run_callbacks :save
                #  puts "Attachment file name"
                #  @file_name = self.attachment.path(dynamic_style_format_symbol)
                #end
              elsif resp.is_a?( Net::HTTPRedirection )
                @uri = URI.parse( resp['location'] )
                compute_uri_hash!
                download_and_process
              else
                raise ImageDownloadError,  "Couldn't download image at uri #{@uri.to_s}, server returned status: #{resp.code}"
              end
            end
          rescue SocketError
            raise ImageDownloadError,  "Couldn't download image at uri #{@uri.to_s}, couldn't connect to @host#{' on port ' + @port if @port}"
          end
        end
      end
    end
  end
end