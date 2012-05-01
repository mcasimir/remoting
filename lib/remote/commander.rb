module Remote
  class Commander

    def exec(*commands)
      do_exec(normalized_command_list(commands))
    end

    protected

    def normalized_command_list(cmds)
      cmds.flatten.map! do |c|
        c.split(/[\r\n]/).map{|l|
          line = l.strip
          line.empty? ? nil : line
        }
      end.flatten.compact
    end
    
  end
end