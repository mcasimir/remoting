module Remote
  module Strategies
    class GitPassengerStrategy < Remote::Strategy
      include CommonCommands
      
      def do_deploy
        remote(
           cd(config.dest), 
           cmd(:git, "pull")
        )
      end

      def do_restart
        remote(
            cmd(:mkdir, '-p', dest.join('tmp'))
            cmd(:touch, dest.join('tmp', 'restart.txt')
        )
      end

      def do_bundle
        remote( 
                load_rvm, 
                use_ruby(config.ruby]),
                ensure_gemset!(config.gemset, config.ruby),
                cd(config.dest),
                "RAILS_ENV=production bundle install --without development test --deployment"
        )
      end

      def do_rake(task)
        remote( 
                load_rvm, 
                use_ruby(config.ruby),
                ensure_gemset!(config.gemset, config.ruby),
                cd(config.dest),
                "RAILS_ENV=production bundle exec rake #{task}"
        )
      end
    
      def do_log(lines = 100, filename = production)
        filename = "#{filename}.log" unless filename =~ /\.[a-z]+$/
        remote(
                cd(config.dest),
                tail(lines, filename)
              )
      end      
            
      protected
            
      def dest
        Pathname.new(config.dest)
      end
      
    end
  end
end