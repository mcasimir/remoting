namespace :remote do
  desc "Restart the server"
  task :restart do
    require 'remoting/task'
    
    remote('restart', config.login) do
      mkdir '-p', config.dest.join('tmp')
      touch config.dest.join('tmp', 'restart.txt') 
    end
    
  end

  desc "First deploy"
  task :first_deploy => [
    :"remote:bare:setup", 
    :"remote:init", 
    :"remote:deploy", 
    :"remote:apache:ensite", 
    :"remote:apache:reload", 
    :"remote:db:create", 
    :"remote:db:migrate", 
    :"remote:db:seed",
    :"remote:assets:precompile",
    :"remote:restart"
  ]

  namespace :apache do
    task :ensite do
      require 'remoting/task'
      remote('ensite', config.login, :interactive => true) do
        cd "/etc/apache2/sites-enabled"
        sudo "ln -s #{config.dest.join('config', 'apache.conf')} #{config.app}"
      end
    end
    
    task :reload do
      require 'remoting/task'

      remote('reload', config.login, :interactive => true) do
        sudo "/etc/init.d/apache2 reload"
      end
    end
  end
end
