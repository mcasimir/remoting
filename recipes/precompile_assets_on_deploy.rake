namespace :remote do
  namespace :assets do

    desc 'Precompile assets'
    task :compile do
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


