require 'rubyserial'
require 'net/http'
require 'ostruct'
require 'remote_syslog_logger'
require 'yaml'
Dir.glob(File.expand_path('../../lib/**/*.rb', __FILE__))
   .each { |file| require file }
HiveBot.config.env = ENV['HIVEBOT_ENV'] || 'development'
unless HiveBot.config.env == 'test'
  require_relative "#{HiveBot.root}/config/hive_bot.rb"
end
