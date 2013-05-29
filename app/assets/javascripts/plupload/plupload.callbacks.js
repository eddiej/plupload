jQuery(document).ready(function($){	     
  uploader.init();
  var queueMaxima = 1;
  
  
  // 1. Files are Added
  uploader.bind('FilesAdded', function(up, files) {   	      
    $.each(files, function(i, file) {
  	  $('#filelist').append('<div id="' + file.id + '" class="file"><span class="progbar"></span><span class="filedetails">' + file.name + ' (' + plupload.formatSize(file.size) + ') <b></b></span><span id="deleteupload">x</span>' + '</div>');
  	});     		
  	if(up.files.length > queueMaxima){
      while(up.files.length > queueMaxima){
        if(up.files.length > queueMaxima){
          x = up.files[queueMaxima-1]
          $('#'+x.id).remove();
          uploader.removeFile(up.files[queueMaxima-1]);
          uploader.stop()
    	  }
      }
      if(typeof(plupload_hook_removedExcessFromQueue) == "function"){plupload_hook_removedExcessFromQueue()}
    }
    up.start();
  	up.refresh(); // Reposition Flash/Silverlight
  });
  

  // 2. Upload Progresses
  uploader.bind('UploadProgress', function(up, file) {
	  $('#' + file.id + " b").html(file.percent + "%");
  	$('span.progbar').width(file.percent + "%");
  });
  
  	
  // 3. Error Occurs
  uploader.bind('Error', function(up, err) {	  
  	$('#filelist').append("<div>Error: " + err.code + ", Message: " + err.message + (err.file ? ", File: " + err.file.name : "") + "</div>");
  	up.refresh(); // Reposition Flash/Silverlight
  });
  
  
  // 4. File Uploaded
  uploader.bind('FileUploaded', function(up, file) { 
    console.info('File Uploaded.')
  }); //end bind 
  

  // 5. Stop button is clicked.
  $('#filelist').on('click', '#deleteupload, #processingupload', function(){
    uploader.stop();
    if(typeof(plupload_hook_stopUpload) == "function"){
      plupload_hook_stopUpload(this, function(){
        uploader.refresh();
      }
    )}
  });
  
}); //end doc ready