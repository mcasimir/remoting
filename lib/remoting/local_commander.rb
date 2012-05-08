require 'remoting/commander'

module Remoting
  class LocalCommander < Commander
    
    #overrides
    def do_exec(cmds)
      local(cmds)
    end
    
    def local(cmds)
      runline = cmds.map{|c| "#{c} 2>&1"}.join(";")
#      puts "[LOCAL]  Executing '#{runline}' ..."
      puts `#{runline}`
    end 
    
  end
end
