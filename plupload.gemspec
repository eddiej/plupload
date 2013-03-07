# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'plupload/version'

Gem::Specification.new do |gem|
  gem.name          = "plupload"
  gem.version       = Plupload::VERSION
  gem.authors       = ["Eddie Johnston"]
  gem.email         = ["eddie@beanstalk.ie"]
  gem.description   = %q{Plupload made simple}
  gem.summary       = %q{Makes Plupload easier to use across projects.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.require_paths = ["lib"]
end
