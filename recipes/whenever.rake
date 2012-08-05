namespace :remote do
  desc "Update crontab with whenever schedule"
  task :whenever do
    require 'remoting/task'

    remote('whenever', config.login) do
      cd  config.dest
      whenever "-w"
    end    
  end
end  
