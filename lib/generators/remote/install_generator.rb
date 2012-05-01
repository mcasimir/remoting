module Remote
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
    end
  end
end