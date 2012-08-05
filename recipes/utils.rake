namespace :remote do

  desc "Dump some remote environment info"
  task :info do
    require 'remoting/task'    
    remote('info', config.login) do

      source "/usr/local/rvm/scripts/rvm"
      which :ruby
      echo "RUBY    VERSION: `ruby --version`"
      echo "RUBYGEM VERSION: `gem --version`"
      command "RVM_VER=`rvm --version`"
      echo "RVM     VERSION: $RVM_VER"
    end
  end

  desc "Open a remote shell session on server"
  task :ssh do
    require 'remoting/task'
    remote('ssh', config.login, :interactive => true) do
    end
  end
  
end