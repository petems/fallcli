# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fallcli/version'

Gem::Specification.new do |gem|
  gem.name          = "fallcli"
  gem.version       = FallCli::VERSION
  gem.authors       = ["Peter Souter"]
  gem.email         = ["p.morsou@gmail.com"]
  gem.description   = %q{A curses CLI app for Dropbox}
  gem.summary       = %q{FallCli is a curses CLI app for Dropbox}
  gem.homepage      = "https://github.com/petems/fallcli"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "thor", "~> 0.18.1"
  gem.add_dependency "middleware" , "~> 0.1.0"

  gem.add_dependency "dropbox-api-petems", "1.1.0"
  gem.add_dependency "dispel", "0.0.7"

  gem.add_development_dependency "rake", "~> 10.1.0"
  gem.add_development_dependency "rspec-core", "~> 2.13.0"
  gem.add_development_dependency "rspec-expectations", "~> 2.13.0"
  gem.add_development_dependency "rspec-mocks", "~> 2.13.0"
  gem.add_development_dependency "webmock", "~> 1.11.0"
  gem.add_development_dependency "coveralls", "~> 0.7.1"

end
