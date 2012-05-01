# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "remote"
  gem.homepage = "http://github.com/mcasimir/remote"
  gem.license = "MIT"
  gem.summary = %Q{Deploy applications with Rake task}
  gem.description = %Q{Remote is a lightweight alternative to Capistrano that is suitable for small projects. It provides some common Deploying Strategies (eg. git + passenger + rvm) and a little framework to run remote commands over SSH with a DSL to define remote scripts.}
  gem.email = "maurizio.cas@gmail.com"
  gem.authors = ["mcasimir"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new