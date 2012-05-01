module Remote
  module Strategies
    
    module CommonCommands
      extend ActiveSupport::Concern
    
      protected
      
      def cmd(*args)
        args.map(&:to_s).join(' ')
      end
    
      def use_ruby(ver)
        "rvm use #{ver}"
      end
      
      def load_rvm
        "[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm"
      end
      
      def cd(dest)
        "cd #{dest}"
      end
      
      def rvm(*args)
        args.map(&:to_s).join(' ')
      end

      def rvm(*args)
        "rvm " << args.map(&:to_s).join(' ')
      end
      
      def gem_install(*gems)
        "gem install " << args.map(&:to_s).join(' ') << " --no-ri --no-rdoc"
      end

      def tail(lines, filename)
        "tail -#{lines} log/#{filename}"
      end

      def pipe(*args)
        args.map(&:to_s).join(' | ')
      end

      def gemset_exists?(gemset, ruby)
        remote( load_rvm,
                use_ruby(ruby),
                "rvm gemset list | egrep ^[\\ ]+#{gemset}[\\ ]*$  | wc -l"
              ).to_i > 0
      end
      
      def ensure_gemset!(gemset, ruby)
        if gemset && !gemset_exists?(gemset, ruby)
          [
            rvm(:gemset, :create, gemset),
            rvm(:gemset, :use, gemset),
            gem_install(:bundler)
          ]               
        else
          [] 
        end
      end

    end
    
  end
end