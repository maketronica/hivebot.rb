require 'rspec/core/rake_task'
require './lib/hivebot'

task :default => [:spec]

task :run do
  Hivebot.new.run
end

task :spec do
  RSpec::Core::RakeTask.new(:spec)
end
