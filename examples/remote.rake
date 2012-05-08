namespace :remote do

  task :info do
    require 'remoting/task'
    
    remote('info', config.login) do
      source "~/.profile"
      source "$HOME/.rvm/scripts/rvm"
      
      which :ruby
      echo "RUBY    VERSION: `ruby --version`"
      echo "RUBYGEM VERSION: `gem --version`"
      command "RVM_VER=`rvm --version`"
      echo "RVM     VERSION: $RVM_VER"
    end
  end

  desc "Setup git origin"
  task :init do
    require 'remoting/task'
    
    local('init') do
      git :init
      git :remote, :add, :origin, config.repo
    end  
  end
  
  desc "Initialize remote"
  task :setup do
    require 'remoting/task'
    
    remote('setup', config.login) do
      git :clone, config.repo, config.dest
    end
  end

  desc "Commit everything to remote git repository"
  task :push, [:message] do |t, args|
    require 'remoting/task'
    
    message = args[:message] || "commit #{Time.now}"

    local('push') do
      git :add, "."
      git :commit, "-a", "-m", "\"#{message}\""
      git :push
    end
  end
  
  desc "Update remote code pulling from repository"
  task :pull_on_remote do
    require 'remoting/task'
    
    schema        = config.dest.join('db', 'schema.rb')
    tmp_schema    = config.tmp.join("#{config.app}_#{Time.now.to_i}_schema.rb.tmp")

    remote('pull_on_remote', config.login) do
      cd  config.dest      
      command("[[ -f \"#{schema}\" ]] && cp #{schema} #{tmp_schema}")
      rm schema
      git :checkout, 'db/schema.rb'
      git :pull
      command("[[ -f \"#{tmp_schema }\" ]] && mv #{tmp_schema} #{schema}")
    end

  end
  
  desc "Restart the server"
  task :restart do
    require 'remoting/task'
    
    remote('restart', config.login) do
      mkdir '-p', config.dest.join('tmp')
      touch config.dest.join('tmp', 'restart.txt') 
    end
    
  end
  
  desc "Hard reset repo on server"
  task :reset do
    require 'remoting/task'

    remote('reset', config.login) do
      cd  config.dest
      git :reset , "--hard HEAD"
      git :clean, "-f", "-d"
    end    

  end
  
  desc "Run bundle install on the server"
  task :bundle do
    require 'remoting/task'

    remote('bundle', config.login) do
      source "~/.profile"
      source "$HOME/.rvm/scripts/rvm"
      rvm :use, config.ruby

      cd  config.dest
      export "LANG=en_US.UTF-8"
      command "RAILS_ENV=production", "bundle install", "--without development test", "--deployment"
    end
  end
  
  desc "Deploy application on server"
  task :deploy => [:push, :pull_on_remote, :bundle, :restart] do
  end

  desc "Run rake tasks on server"
  task :rake, [:invocation] do |t, args|
    require 'remoting/task'

    invocation = args[:invocation]

    remote('rake', config.login, :interactive => true) do 
      source "$HOME/.rvm/scripts/rvm"
      rvm :use, config.ruby

      cd  config.dest
      command("RAILS_ENV=production bundle exec rake #{invocation}")
    end        
    
  end

  desc "Open a remote shell session on server"
  task :ssh do
    require 'remoting/task'
    remote('ssh', config.login, :interactive => true) do
    end
  end
  
  desc "Dump a remote logfile"
  task :log, [:lines, :filename] do |t, args|
    require 'remoting/task'

    filename, lines = args.values_at(:lines, :filename)
    filename ||= "production"
    filename = "#{filename}.log" unless filename =~ /\.[a-z]+$/
    
    lines ||= 100
    
    remote('log', config.login) do
      cd config.dest
      tail "-#{lines} log/#{filename}"
    end
  end

  task :logs => [:log] do
  end
  
  
  desc "Run tail -f on logfile"
  task :logtail, [:filename] do |t, args|
    require 'remoting/task'

    filename=  args[:filename]
    filename ||= "production"
    filename = "#{filename}.log" unless filename =~ /\.[a-z]+$/
        
    remote('logtail', config.login) do
      cd config.dest
      tail "-f log/#{filename}"
    end
  end

  desc "Open a remote console"
  task :console do
    require 'remoting/task'

    remote('console', config.login, :interactive => true) do
      cd config.dest
      source '$HOME/.rvm/scripts/rvm'
      bundle :exec, "rails c production"
    end
  end

  desc "Update crontab with whenever schedule"
  task :whenever do
    require 'remoting/task'

    remote('whenever', config.login) do
      cd  config.dest
      whenever "-w"
    end    
  end
  
  
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
  
  namespace :assets do

    desc 'Precompile assets'
    task :precompile do
      require 'remoting/task'

      remote('rake assets:precompile', config.login) do
      
          source "$HOME/.rvm/scripts/rvm"
          rvm :use, config.ruby
          cd  config.dest
          command("RAILS_ENV=production bundle exec rake assets:precompile")
          echo 'restarting ...'
          mkdir '-p', config.dest.join('tmp')
          touch config.dest.join('tmp', 'restart.txt') 
          
      end      
    end
  end
  
  namespace :db do

      desc "Migrate remote database"
      task :migrate do |t, args|
        require 'remoting/task'
    
        remote('rake db:migrate', config.login) do
          source "$HOME/.rvm/scripts/rvm"
          rvm :use, config.ruby
          cd  config.dest
          command("RAILS_ENV=production bundle exec rake db:migrate")
        end    
      end
  end

end