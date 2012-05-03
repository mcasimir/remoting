# Remote

*Remote* is a great way to turn plain rake tasks in scripts to administer the server remotely. It provides a little framework to run remote commands over SSH along with a DSL to define remote scripts.

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

Just require `remote/task` inside your tasks. NOTE: you can also require it globally but is not recommended cause here `String` is patched to enable bash-flavoured syntax.

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

### DSL

By examples
  
    remote("my task", config.login) do 

      ps("aux") | grep("mysql") 
      echo 'noise' > "/dev/null"
      echo 'setting=value' >> "settings.conf"
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

Invoking `remote` with `:interactive => true` will tell `remote` to yield the process to ssh, this way you will remotely interact with the server. On the other side everithing that is supposed to be executed after `remote` wont run. Despite this interactive tasks are very useful.

#### Example 1. Rails remote console (by popular demand):
  
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
    
####  Example 2. Reloading Apache configuration (involves sudo):
    
    task :reload do
      require 'remote/task'

      remote('reload', config.login, :interactive => true) do
        sudo "/etc/init.d/apache2 reload"
      end
    end

    

## A note on modularity

A complete deployment manager (like Capistrano even if probably not as good as it is) can be easily built over *remote*. Capistrano recipes can be ordinary rake tasks packed as gems. Plus various _deployment strategies_ can be assembled as dependencies of a main `deploy` task.

    # Gemfile
    gem 'remote_scm_git'          # provides 'remote:scm:push'
    gem 'remote_server_passenger' # provides 'remote:server:restart'

    # remote.rake
    desc "Deploy application on server"
    task :deploy => ["remote:scm:push", "remote:scm:pull", "remote:bundle", "remote:server:restart"] do
    end


## Examples

You can find more examples under `examples` source directory


## Coming Soon

* Ability to define bunch of commands as functions
* Pre-packed strategies     

-----------------------------------------

Copyright (c) 2012 mcasimir

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


