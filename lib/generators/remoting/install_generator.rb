module Remoting
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :host, :default => "remote"
      class_option :user, :default => "ror"
      
      def create_remote_yml
        appname = Rails.application.class.to_s.split("::").first.underscore
        host = options[:host]
        user = options[:user] 
        
        stub = <<-STUB
remote:
  login: #{user}@#{host}
  dest: /var/#{user}/#{appname}
  repo: ssh://#{user}@#{host}/var/ror/git/#{appname}.git
  ruby: 1.9.3
  tmp: /tmp
  app: #{appname}
        STUB
        
        create_file "config/remote.yml", stub
        
      end
      
      def create_remote_rake
        
        create_file "lib/tasks/remote/remote.rake", <<-eos
namespace :remote do
  desc "Deploy application on server"
  task :deploy => [:push, :bundle, :"assets:compile", :restart] do
  end
end
        
eos
        
        
      end
      
      
    end
  end
end