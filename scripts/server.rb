require_relative '../config/environment.rb'
Dir.chdir File.expand_path('../..', __FILE__)
Hivebot.new.run
