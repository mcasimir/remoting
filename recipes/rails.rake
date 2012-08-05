namespace :remote do
  
  desc "Run bundle install on the server"
  task :bundle do
    require 'remoting/task'

    remote('bundle', config.login) do
      source "/usr/local/rvm/scripts/rvm"
      rvm :use, config.ruby

      cd  config.dest
      export "LANG=en_US.UTF-8"
      command "RAILS_ENV=production", "bundle install", "--without development test", "--deployment"
    end
  end
  
  desc "Run rake tasks on server"
  task :rake, [:invocation] do |t, args|
    require 'remoting/task'

    invocation = args[:invocation]

    remote('rake', config.login, :interactive => true) do 
      source "/usr/local/rvm/scripts/rvm"
      rvm :use, config.ruby
      cd  config.dest
      command("RAILS_ENV=production bundle exec rake #{invocation}")
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
      source "/usr/local/rvm/scripts/rvm"
      bundle :exec, "rails c production"
    end
  end
  
  namespace :db do
      desc "Migrate remote database"
      task :migrate do |t, args|
        require 'remoting/task'
    
        remote('rake db:migrate', config.login) do
          source "/usr/local/rvm/scripts/rvm"
          rvm :use, config.ruby
          cd  config.dest
          command("RAILS_ENV=production bundle exec rake db:migrate")
        end
      end
      
      desc "Seed remote database"
      task :seed do |t, args|
        require 'remoting/task'
    
        remote('rake db:seed', config.login) do
          source "/usr/local/rvm/scripts/rvm"
          rvm :use, config.ruby
          cd  config.dest
          command("RAILS_ENV=production bundle exec rake db:seed")
        end
      end        
  end
  
  
  namespace :assets do

    desc 'Precompile assets'
    task :precompile do
      require 'remoting/task'

      remote('rake assets:precompile', config.login) do
          source "/usr/local/rvm/scripts/rvm"
          rvm :use, config.ruby
          cd  config.dest
          command("RAILS_ENV=production bundle exec rake assets:precompile")
          echo 'restarting ...'
          mkdir '-p', config.dest.join('tmp')
          touch config.dest.join('tmp', 'restart.txt') 
          
      end      
    end

  end
  
  
end