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
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "remoting"
  gem.homepage = "http://github.com/mcasimir/remoting"
  gem.license = "MIT"
  gem.summary = %Q{Turn plain rake tasks in scripts to administer the server remote.}
  gem.description = %Q{Remoting is a great way to turn plain rake tasks in scripts to administer the server remote. It provides a little framework to run remoting commands over SSH along with a DSL to define remoting scripts.}
  gem.email = "maurizio.cas@gmail.com"
  gem.authors = ["mcasimir"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new