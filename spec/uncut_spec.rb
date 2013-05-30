require 'spec_helper'


describe StartupGiraffe::Uncut::Image do
  before {
    @test_img_uri = URI.parse( "http://dealix.images.dmotorworks.com/400365/1GYS4CEF3BR185018/full/1.jpg?#{BSON::ObjectId.new.to_s}" )
    @img = StartupGiraffe::Uncut::Image.new( @test_img_uri.host, @test_img_uri.request_uri, "100x100>" )
  }

  after {
    Kernel.system( "rm -rf #{StartupGiraffe::Uncut::Image.tmp_dir}/*" )
  }

  context "when cutting to 100x100>" do

    describe "cut image" do
      before {
        @img.download_and_process
      }

      it "reduces the size of the image from original" do
        orig_size = File.size( "#{StartupGiraffe::Uncut::Image.tmp_dir}/#{@img.uri_hash}" )
        cut_size = File.size( @img.file_name )
        orig_size.should > cut_size
      end

      it "has mime type of image/jpeg" do
        @img.mime_type.should == "image/jpeg"
      end

      it "results in an image 100 pixels wide" do
        img = Magick::Image::read( @img.file_name ).first
        img.columns.should == 100
      end
    end

    context "the second time" do
      before {
        @img.download_and_process
        @img2 = StartupGiraffe::Uncut::Image.new( @test_img_uri.host, @test_img_uri.request_uri, "100x100>" )
      }

      it "should know the cached mime type" do
        expect {
          @img2.download_and_process
        }.to change { @img2.mime_type }.to "image/jpeg"
      end

      it "should not re-download" do
        sleep 1
        expect {
          @img2.download_and_process
        }.not_to change { File.mtime( StartupGiraffe::Uncut::Image.tmp_dir + "/#{@img2.uri_hash}" ).to_i }
      end

      it "should not re-process" do
        sleep 1
        expect {
          @img2.download_and_process
        }.not_to change { File.mtime( @img.file_name ).to_i }
      end

      it "should point to the same tmp file" do
        @img2.download_and_process
        @img.file_name.should == @img2.file_name
      end
    end
  end
end