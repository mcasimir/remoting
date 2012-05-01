require 'remote/dsl/script_builder'
require 'remote/local_commander'
require 'remote/remote_commander'
require 'remote/shell'

module Remote
  module Task
    
    def config
      Remote.config
    end
    
    def local(name = nil, &block)
      bold("Executing '#{name}' on local ...")
      commands  = ::Remote::Dsl::ScriptBuilder.build(&block)
      commander = LocalCommander.new
      run(commander, commands) 
    end 

    def remote(name = nil, login, &block)
      bold("Executing '#{name}' on '#{login}' ...")
      commands = ::Remote::Dsl::ScriptBuilder.build(&block)      
      commander = RemoteCommander.new(login)
      run(commander, commands)
    end
    
    def run(commander, commands)
      succeded = commander.exec(commands)
      if succeded
        success("Script execution completed succesfully")
      else
        error("Script execution terminated with an error status")
      end
      succeded
    end

    def shell
      @shell ||= Shell.new
    end

    %w(bold error success yes? no? say continue?).each do |meth|
      eval("def #{meth}(*args);shell.#{meth}(*args);end")
    end

  end
end


include Remote::Task




