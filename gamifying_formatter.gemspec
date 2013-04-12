# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "gamifying_formatter"
  gem.version       = '0.0.1'
  gem.authors       = ["Chris Belsole"]
  gem.email         = ["cbelsole@gmail.com"]
  gem.description   = %q{The Gamifying Formatter}
  gem.summary       = %q{An rspec formatter for making testing fun.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency 'rspec'
end
