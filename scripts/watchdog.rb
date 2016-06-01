#!/usr/bin/ruby
ENV['HIVEBOT_ENV'] = 'production'
require_relative '../config/environment.rb'
begin
  result = `ping -q -c 10 #{HiveBot::Configuration.new.address}`
  if $CHILD_STATUS != 0
    HiveBot.logger.info('Mom did not respond to ping. Re-networking.')
    HiveBot.logger.info(result)
    `/usr/sbin/service network-manager restart`
  else
    HiveBot.logger.info('Mom responded to ping.')
    HiveBot.logger.info(result) unless result =~ / 0% packet loss/
  end
end
