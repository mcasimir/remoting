module Remote
  module Generators
    class StrategyGenerator < Rails::Generators::NamedBase
      def create_strategy_stub
        
        stub = <<-STUB
module Remote
  module Strategies
    class #{class_name}Strategy < Remote::Strategy


      def validate_config!
        # here you can check configuration
        # and raise an error in case of missing or 
        # bad attributes

        # you can safely delete this method to skip validation
      end
        
      def do_push(message)

      end
            
      def do_deploy

      end

      def do_bundle

      end

      def do_restart

      end
        
      def do_rake(task)

      end
    
      def do_setup

      end
    
      def do_log(lines, filename)

      end
          
    end
  end
end
        STUB
        
        create_file "config/remote.yml", stub
        
      end
    end
  end
end