#!/usr/bin/env bash
parent_path=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )
cd "$parent_path"

sudo apt-get install ruby-dev
sudo gem install bundler --no-rdoc --no-ri
bundle install

sudo cp ../scripts/init.rb /etc/init.d/hivebot
sudo chmod 755 /etc/init.d/hivebot
sudo update-rc.d hivebot defaults
sudo service hivebot restart

sudo cp ../scripts/watchdog.cron /etc/cron.d/hivebotwatchdog
