require 'remote/dsl/script_builder'
require 'remote/local_commander'
require 'remote/remote_commander'
require 'remote/shell'

module Remote
  module Task
    
    def _remote_task_included
    end
    
    def config
      Remote.config
    end
    
    def local(name, *args, &block)
      bold("Executing '#{name}' on local ...")
      commands  = ::Remote::Dsl::ScriptBuilder.build(&block)
      commander = LocalCommander.new(*args)
      run(commander, commands) 
    end 

    def remote(name, login, *args, &block)
      bold("Executing '#{name}' on '#{login}' ...")
      commands = ::Remote::Dsl::ScriptBuilder.build(&block)      
      commander = RemoteCommander.new(login, *args)
      run(commander, commands)
    end
    
    def run(commander, commands)
      commander.exec(commands)
    end

    def shell
      @shell ||= ::Remote::Shell.new
    end

    %w(bold error success yes? no? say continue?).each do |meth|
      eval("def #{meth}(*args);shell.#{meth}(*args);end")
    end

  end
end

unless self.respond_to?(:_remote_task_included)
  include Remote::Task
end



