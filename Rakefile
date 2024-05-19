require 'bundler/gem_tasks'
Bundler.require
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['test/*test.rb']
end

desc 'Build test harness'
task :build_harness do
  system 'bundle', 'exec', 'tools/test-harness'
end

task :default => :test