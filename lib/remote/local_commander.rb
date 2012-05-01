module Remote
  class LocalCommander < Commander
    
    #overrides
    def exec(*cmds)
      local(*cmds)
    end
    
    def local(*cmds)
      runline = command_list(cmds).map{|c| "#{c} 2>&1"}.join(";")

      puts "[LOCAL]  Executing '#{runline}' ..."
      puts `#{runline}`
    end 
    
  end
end
