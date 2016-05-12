ENV['HIVEBOT_ENV'] = 'production'
require_relative '../config/environment.rb'
begin
  HiveBot.logger.info('Starting up')
  Dir.chdir HiveBot.root
  HiveBot::Server.new.run
rescue Exception => e
  HiveBot.logger.fatal("Bot died with: #{e} : #{e.class} :  #{e.message}")
  e.backtrace.each do |line|
    HiveBot.logger.fatal(line)
  end
  raise e
ensure
  HiveBot.logger.info('Shutting Down')
end
