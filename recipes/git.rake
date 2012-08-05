namespace :remote do
  
  desc "Commit everything to remote git repository"
  task :push do
    require 'remoting/task'
    
    message = ENV["MESSAGE"] || "commit #{Time.now}"

    local('push') do
      git :add, "."
      git :commit, "-a", "-m", "\"#{message}\""
      git :push, "origin", "+master:refs/heads/master"
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

  desc "Grab changes from remote git repository"
  task :pull do
   require 'remoting/task'
    
    local('pull') do
      git :pull, :origin, :master
    end
  end
  
    
end