require 'remote/dsl/script_builder'
require 'remote/local_commander'
require 'remote/remote_commander'

module Remote
  module Task
    
    def locally(&block)
      commands  = ScriptBuilder.build(&block)
      p commands
#      commander = LocalCommander.new
#      commander.exec(commands) 
    end 

    def remotely(&block)
      commands = ScriptBuilder.build(&block)
      
    end     
  end
end