module Remoting
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def create_remote_yml
        
        stub = <<-STUB
remote:
  login: user@server
  dest: /var/ror/myapp
  repo: git@gitserver:myapp
  ruby: 1.9.3
  gemset: myapp        
        STUB
        
        create_file "config/remote.yml", stub
        
      end
      
      def create_remote_rake
        
        create_file "lib/tasks/remote.rake", <<-eos
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