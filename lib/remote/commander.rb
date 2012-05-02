module Remote
  class Commander

    def exec(commands)
      commands << 'echo $?'
      retval = do_exec(commands)
      retval.to_i == 0
    end

  end
end