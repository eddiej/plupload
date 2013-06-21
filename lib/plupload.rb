require "plupload/version"

module Plupload
  require 'plupload/engine'
  
  module PluploadHelper 
    def setup
      javascript_tag(%(
        $(document).ready(function() {
          alert('pop');
        } );
      %))
    end
    
    def simple_p(options = {})
       
       # Read in the default bucket, AWS key and secret from environment variables.
       bucket = ENV['S3_BUCKET']
       access_key_id = ENV['AWS_ACCESS_KEY_ID']
       secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
       
       options[:key] ||= 'test' # folder on AWS to store file in
       options[:acl] ||= 'public-read'
       options[:expiration_date] ||= 10.hours.from_now.utc.iso8601
       options[:max_filesize] ||= 500.megabytes
       options[:content_type] ||= 'image/' # Videos would be binary/octet-stream
       options[:filter_title] ||= 'Images'
       options[:filter_extentions] ||= 'jpg,jpeg,gif,png,bmp'

       id = options[:id] ? "_#{options[:id]}" : ''

       policy = Base64.encode64(
         "{'expiration': '#{options[:expiration_date]}',
           'conditions': [
             {'bucket': '#{bucket}'},
             {'acl': '#{options[:acl]}'},
             {'success_action_status': '201'},
             ['content-length-range', 0, #{options[:max_filesize]}],
             ['starts-with', '$key', ''],
             ['starts-with', '$Content-Type', ''],
             ['starts-with', '$name', ''],
             ['starts-with', '$Filename', '']
           ]
           }").gsub(/\n|\r/, '')

       signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'),secret_access_key, policy)).gsub("\n","")
       out = ""
       filters = "filters : [
         {title : '#{options[:filter_title]}', extensions : '#{options[:filter_extentions]}'}
       ],"
       if options[:filters]
         filters = 'filters : ['
         filters = filters + options[:filters].join(',')
         filters = filters + "],"
       end
       out << javascript_tag("
       // function pad(n) { return ('0' + n).slice(-2); }
       // function get_time_stamp() {
       // var d = new Date();
       //   return( pad(d.getYear())+''+pad(d.getMonth()+1)+''+pad(d.getDate())+'-'+pad(d.getHours())+''+pad(d.getMinutes())+''+pad(d.getSeconds()) );
       // };
       
       $(function() {
         uploader = new plupload.Uploader({
           browse_button : 'pickfiles',
           container : 'uploadcontainer',
           runtimes : 'html5',
           url : 'http://#{bucket}.s3.amazonaws.com/',
           max_file_size : '10mb',
           multipart: true,
           multipart_params: {
             'key': '#{options[:key]}/${filename}',
             'Filename': '${filename}', // adding this to keep consistency across the runtimes
             'acl': '#{options[:acl]}',
             'Content-Type': '#{options[:content_type]}',
             'success_action_status': '201',
             'AWSAccessKeyId' : '#{access_key_id}',
             'policy': '#{policy}',
             'signature': '#{signature}'
           },
           // optional, but better be specified directly
           file_data_name: 'file',
           // re-use widget (not related to S3, but to Plupload UI Widget)
           multiple_queues: true,
           // Specify what files to browse for
           #{filters}
           // Flash settings
           flash_swf_url : '/assets/plupload/plupload.flash.swf',
           // Silverlight settings
           silverlight_xap_url : '/assets/plupload/plupload.silverlight.xap',


           // Add randomness to the filename.
           // Dont do this, rather upload the file into a user subdirectory
           // preinit : {UploadFile: function(up, file) {
           //  up.settings.multipart_params.key = up.settings.multipart_params.key.replace(/\\/[^\\/]*\\${filename}/, '/'+get_time_stamp()+'-${filename}')
           // }}
         });
       });")
     raw(out);
     end
    
  
    
  end
  ActionView::Base.send :include, PluploadHelper
  
  
end
