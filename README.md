# Remote

*Remote* is a small alternative to Capistrano that is suitable to write remote management scripts with rake task. It provides a little framework to run remote commands over SSH with a DSL to define remote scripts.

Install

    gem 'remote', :git => "git@github.com:mcasimir/remote.git"
    
Update your bundle
  
    bundle install

Generate `remote.yml` stub

    rails g remote:install

Edit `config/remote.yml`

    remote:
      any_setting_you_like: Here you can define properties that will be available in 'config' struct inside rake tasks!
      example: Below are some tipical configuration settings you may wish to define:
      login: user@server
      dest: /var/ror/myapp
      repo: git@gitserver:myapp.git
      ruby: 1.9.3
      gemset: myapp
      

## Usage

Just require 'remote/task' inside your tasks. You can also require it globally but is not recommended cause here `String` is patched to enable bash-flavoured syntax.

_ex._

    desc "Restart the server"
    task :restart do
      require 'remote/task'
    
      remote('restart', config.login) do
       mkdir '-p', config.dest.join('tmp')
       touch config.dest.join('tmp', 'restart.txt') 
      end
    
    end
 
Methods invoked inside the `remote` block are executed inside a ssh session. `remote` takes two arguments: `name` and `login`. `name` serves only for logging purposal while `login` is the login string to access the server supplied in the form of `user@host`

## DSL

By examples
  
    remote("my task", config.login) do 

      ps("aux") | grep("mysql") 
      echo 'noise' > "/dev/null"
      echo 'setting=value' >> "ettings.conf"
      tail -100 config.dir.join('log', 'logfile.log')
      command("[[ -f \"path\" ]] && run_a_command")

    end

### Local Tasks using DSL

You can also define local tasks using the same DSL

    desc "Setup git origin"
    task :init do
      require 'remote/task'
    
      local('init') do
        git :init
        git :remote, :add, :origin, config.repo
      end  
    end

Methods invoked inside the `local` block are executed locally. `local` takes only the `name` parameter.


### Interactive tasks

One example over all:
  
  # my_remote_task.rake

  desc "Open rails console on server"
  task :console do
    require 'remote/task'

    remote('console', config.login, :interactive => true) do
      cd config.dest
      source '$HOME/.rvm/scripts/rvm'
      bundle :exec, "rails c production"
    end
  end

Note: interactive ... ( to be continued ;) )