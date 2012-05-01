# Remote

_Remote_ is a gem to deploy rails applications through rake task and git. Just a thin alternative to capistrano

install
    gem 'remote', :git => "git@github.com:mcasimir/remote.git"

generate `remote.yml`
    rails g remote:install

edit `config/remote.yml`
    remote:
      login: user@server
      dest: /var/ror/myapp
      repo: git@gitserver:myapp
      ruby: 1.9.3
      gemset: myapp


## Usage

rake remote:deploy



## Coming soon

rake remote:console