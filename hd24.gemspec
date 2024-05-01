Gem::Specification.new do |gem|
  gem.name          = 'hd24'
  gem.version       = '0.1'
  gem.authors       = 'John Labovitz'
  gem.email         = 'johnl@johnlabovitz.com'
  gem.summary       = %q{Reads images from an Alesis HD24 recorder}
  gem.description   = %q{Reads images from an Alesis HD24 recorder.}
  gem.homepage      = 'https://github.com/jslabovitz/hd24.git'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'bindata', '~> 2.5'
  gem.add_dependency 'set_params', '~> 0.2'
  gem.add_dependency 'simple-command', '~> 0.7'
  gem.add_dependency 'simple-dumper', '~> 0.1'
  gem.add_dependency 'simple-printer', '~> 0.3'

  gem.add_development_dependency 'bundler', '~> 2.5'
  gem.add_development_dependency 'minitest', '~> 5.22'
  gem.add_development_dependency 'minitest-power_assert', '~> 0.3'
  gem.add_development_dependency 'rake', '~> 13.2'
end