#!/usr/bin/ruby
ENV['HIVEBOT_ENV'] = 'production'
require_relative '../config/environment.rb'
begin
  result = `ping -q -c 10 #{HiveBot::Configuration.new.address}`
  if ($?.exitstatus != 0)
    HiveBot.logger.info('Mom did not respond to ping. Re-networking.')
    HiveBot.logger.info(result)
    `/usr/sbin/service network-manager restart`
  else
    HiveBot.logger.info('Mom responded to ping.')
    unless result.match(/ 0% packet loss/)
      HiveBot.logger.info(result)
    end
  end
end
