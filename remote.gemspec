# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "remote"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["mcasimir"]
  s.date = "2012-05-02"
  s.description = "Remote is a lightweight alternative to Capistrano that is suitable for small projects. It provides some common Deploying Strategies (eg. git + passenger + rvm) and a little framework to run remote commands over SSH with a DSL to define remote scripts."
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
    "example.yml",
    "lib/generators/remote/install_generator.rb",
    "lib/remote.rb",
    "lib/remote/commander.rb",
    "lib/remote/config.rb",
    "lib/remote/dsl/script_builder.rb",
    "lib/remote/dsl/string.rb",
    "lib/remote/engine.rb",
    "lib/remote/local_commander.rb",
    "lib/remote/remote_commander.rb",
    "lib/remote/shell.rb",
    "lib/remote/ssh.rb",
    "lib/remote/task.rb",
    "remote.gemspec"
  ]
  s.homepage = "http://github.com/mcasimir/remote"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Deploy applications with Rake task"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 3.0"])
      s.add_runtime_dependency(%q<session>, [">= 0"])
      s.add_runtime_dependency(%q<net-ssh>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.3"])
    else
      s.add_dependency(%q<rails>, ["~> 3.0"])
      s.add_dependency(%q<session>, [">= 0"])
      s.add_dependency(%q<net-ssh>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 3.0"])
    s.add_dependency(%q<session>, [">= 0"])
    s.add_dependency(%q<net-ssh>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
  end
end

