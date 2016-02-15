#!/usr/bin/env ruby
require 'rubygems'
require 'daemons'
Daemons.run(File.expand_path('../server.rb', __FILE__))
