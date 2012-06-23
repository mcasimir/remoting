# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "remoting"
  s.version = "0.2.14"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["mcasimir"]
  s.date = "2012-06-23"
  s.description = "Remoting is a great way to turn plain rake tasks in scripts to administer the server remote. It provides a little framework to run remote commands over SSH along with a DSL to define remote scripts."
  s.email = "maurizio.cas@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "examples/remote.rake",
    "examples/remote.yml",
    "lib/generators/remoting/install_generator.rb",
    "lib/remoting.rb",
    "lib/remoting/commander.rb",
    "lib/remoting/config.rb",
    "lib/remoting/dsl/script_builder.rb",
    "lib/remoting/dsl/string.rb",
    "lib/remoting/engine.rb",
    "lib/remoting/local_commander.rb",
    "lib/remoting/remote_commander.rb",
    "lib/remoting/shell.rb",
    "lib/remoting/ssh.rb",
    "lib/remoting/task.rb",
    "pkg/remoting-0.2.13.gem",
    "remoting.gemspec"
  ]
  s.homepage = "http://github.com/mcasimir/remoting"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Turn plain rake tasks in scripts to administer the server remote."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 3.0"])
      s.add_runtime_dependency(%q<net-ssh>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.3"])
    else
      s.add_dependency(%q<rails>, ["~> 3.0"])
      s.add_dependency(%q<net-ssh>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 3.0"])
    s.add_dependency(%q<net-ssh>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
  end
end

