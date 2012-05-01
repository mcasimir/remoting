# Remote

Remote is a lightweight alternative to Capistrano that is suitable for small projects. It provides some common Deploying Strategies (eg. git + passenger + rvm) and a little framework to run remote commands over SSH with a DSL to define remote scripts.}

Install

    gem 'remote', :git => "git@github.com:mcasimir/remote.git"

Generate `remote.yml` stub

    rails g remote:install

Edit `config/remote.yml`

    remote:
      strategy: git_passenger
      login: user@server
      dest: /var/ror/myapp
      repo: git@gitserver:myapp.git
      ruby: 1.9.3
      gemset: myapp


## Usage

Push changes
    
    rake remote:push[my message]

Push and deploy changes
    
    rake remote:deploy

Restart server

    rake remote:restart

Run `bundle install`

    rake remote:bundle

Run a rake task

    rake remote:rake[db:migrate]

Dump a log file

    rake remote:log[100, production] # same as rake remote:log

## Define your own

    # my_task.rake
    
    task :my_remote_task => remote do  
      require 'remote'
      Remote.strategy_eval do 
        remote(cd(dest.join('/tmp'))
          
          )
      
      end      
    end
    
## Coming soon

* rake remote:console
* resolve conflict with schema.rb