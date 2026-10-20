Gem::Specification.new do |gem|
  gem.name          = 'hd24dig'
  gem.version       = '0.1'
  gem.authors       = 'John Labovitz'
  gem.email         = 'johnl@johnlabovitz.com'
  gem.summary       = %q{Extracts audio and other information from an Alesis HD24 ADAT audio recorder}
  gem.description   = %q{Extracts audio and other information from an Alesis HD24 ADAT audio recorder.}
  gem.homepage      = 'https://github.com/jslabovitz/hd24dig.git'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'bindata', '~> 3.0'
  gem.add_dependency 'path', '~> 2.1'
  gem.add_dependency 'set_params', '~> 0.3'
  gem.add_dependency 'simple-command-parser', '~> 1.4'
  gem.add_dependency 'timecode', '~> 2.2'
  gem.add_dependency 'tty-command', '~> 0.10'
  gem.add_dependency 'tty-screen', '~> 0.8'
  gem.add_dependency 'tty-table', '~> 0.12'

  gem.add_development_dependency 'midi-mmc', '~> 0.1'
  gem.add_development_dependency 'minitest', '~> 6.0'
  gem.add_development_dependency 'minitest-power_assert', '~> 0.3'
  gem.add_development_dependency 'pitch', '~> 0.1'
  gem.add_development_dependency 'rake', '~> 13.4'
  gem.add_development_dependency 'simple-rake-tasks', '~> 0.1'
  gem.add_development_dependency 'unimidi', '~> 0.5'

end