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
    
  
    
  end
  ActionView::Base.send :include, PluploadHelper
  
  
end
