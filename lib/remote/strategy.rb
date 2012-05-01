module Remote
  class Strategy
    attr_reader :config
    
    def initialize(config)
      @config = config
      validate_config!
    end
    
    # public interface
    
    # here you can check configuration
    # and raise an error in case of missing or 
    # bad attributes
    
    def validate_config!
      return true
    end
    
    def deploy(message)
      push(message)
      do_deploy()
    end
    
    def reset
      do_reset()
    end
    
    def restart
      do_restart()
    end
    
    def bundle
      do_bundle()
    end
    
    def push(message)
      do_push(message)
    end
    
    def rake(task)
      do_rake(task)
    end
    
    def log(lines, filename)
      do_log(lines, filename)
    end
    
    protected
    
    def remote(*cmds)
      remote_commander.exec(*cmds)
    end
    
    def local(*cmds)
      local_commander.exec(*cmds)
    end
  
    private
  
    def remote_commander
      @remote_commander ||= RemoteCommander.new(config.login)
    end
    
    def local_commander
      @local_commander ||= LocalCommander.new
    end
    
  end
end