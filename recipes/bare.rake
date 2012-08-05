namespace :remote do
  namespace :bare do
    
    desc "Initialize a bare git remote"
    task :setup do
      require 'remoting/task'
      repo_location = config.repo.gsub(/^ssh:\/\/[^\/]+/, "")
      remote('setup', config.login) do
        mkdir "-p", repo_location
        cd repo_location
        git :init, "--bare"
        git "--bare", "update-server-info"
        mkdir "-p", config.dest
        git :config, "core.bare", :false
        git :config, "core.worktree", config.dest
        git :config, "receive.denycurrentbranch", :ignore
        touch "hooks/post-receive"
        command("echo '#!/bin/sh' >> hooks/post-receive")
        command("echo git checkout -f >> hooks/post-receive ")
        chmod "+x", "hooks/post-receive"
      end
    end
    
  end
end