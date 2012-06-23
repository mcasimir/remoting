require 'remoting/dsl/script_builder'
require 'remoting/local_commander'
require 'remoting/remote_commander'
require 'remoting/shell'

module Remoting
  module Task
    
    def _remoting_task_included
    end
    
    def config
      remoting.config
    end
    
    def local(name, *args, &block)
      bold("Executing '#{name}' on local ...")
      commands  = ::Remoting::Dsl::ScriptBuilder.build(&block)
      commander = LocalCommander.new(*args)
      run(commander, commands) 
    end 

    def remote(name, login, *args, &block)
      bold("Executing '#{name}' on '#{login}' ...")
      commands = ::Remoting::Dsl::ScriptBuilder.build(&block)      
      commander = RemoteCommander.new(login, *args)
      run(commander, commands)
    end
    
    def run(commander, commands)
      commander.exec(commands)
    end

    def shell
      @shell ||= ::Remoting::Shell.new
    end

    %w(bold error success yes? no? say continue?).each do |meth|
      eval("def #{meth}(*args);shell.#{meth}(*args);end")
    end

  end
end

unless self.respond_to?(:_remoting_task_included)
  include Remoting::Task
end



