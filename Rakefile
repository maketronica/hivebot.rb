require_relative 'config/environment.rb'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: [:rubocop, :spec]

task :run do
  Hivebot.new.run
end

task :rubocop do
  RuboCop::RakeTask.new
end

task :spec do
  RSpec::Core::RakeTask.new(:spec)
end
