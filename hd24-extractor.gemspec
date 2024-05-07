Gem::Specification.new do |gem|
  gem.name          = 'hd24-extractor'
  gem.version       = '0.1'
  gem.authors       = 'John Labovitz'
  gem.email         = 'johnl@johnlabovitz.com'
  gem.summary       = %q{Extracts audio and other information from an Alesis HD24 ADAT audio recorder}
  gem.description   = %q{Extracts audio and other information from an Alesis HD24 ADAT audio recorder.}
  gem.homepage      = 'https://github.com/jslabovitz/hd24-extractor.git'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'bindata', '~> 2.5'
  gem.add_dependency 'path', '~> 2.1'
  gem.add_dependency 'set_params', '~> 0.2'
  gem.add_dependency 'simple-command', '~> 0.9'
  gem.add_dependency 'simple-dumper', '~> 0.1'
  gem.add_dependency 'simple-printer', '~> 0.3'
  gem.add_dependency 'tty-progressbar', '~> 0.18'
  gem.add_dependency 'tty-screen', '~> 0.8'

  gem.add_development_dependency 'bundler', '~> 2.5'
  gem.add_development_dependency 'minitest', '~> 5.22'
  gem.add_development_dependency 'minitest-power_assert', '~> 0.3'
  gem.add_development_dependency 'rake', '~> 13.2'
end