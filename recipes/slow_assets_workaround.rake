namespace :remote do
  namespace :assets do
  
    desc 'remoting support for rails-slow-assets-workaround'
    task :compile do
      require 'rails-slow-assets-workaround'
      require 'remoting/task'

      remote('rake assets:compile', config.login) do
          source "/usr/local/rvm/scripts/rvm"
          rvm :use, config.ruby
          cd  config.dest
          command("RAILS_ENV=production bundle exec rake assets:compile")          
      end      
    end
    
  end
end
