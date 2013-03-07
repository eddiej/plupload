class PluploadInitializerGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates", __FILE__)
  desc "This generator creates an initializer file at config/initializers"
  def copy_initializer_file
    copy_file "plupload.rb", "config/initializers/plupload.rb"
  end
end
