ENV['HIVEBOT_ENV'] = 'production'
require_relative '../config/environment.rb'
begin
  HiveBot.logger.info('Starting up')
  Dir.chdir HiveBot.root
  HiveBot::Server.new.run
rescue Exception => e
  HiveBot.logger.fatal("Bot died with: #{e.message}")
  HiveBot.logger.fatal(e.backtrace.inspect)
  raise e
ensure
  HiveBot.logger.info('Shutting Down')
end
