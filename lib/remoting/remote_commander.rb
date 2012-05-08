require 'remoting/commander'
require 'remoting/ssh'

module Remoting
  class RemoteCommander < Commander
    
    attr_reader :login, :interactive
    def initialize(login, *args)
      options = args.extract_options!
      @login = login
      @interactive = !!options[:interactive]
    end
    
    #overrides
    def do_exec(cmds)
      remote(cmds)
    end
       
    def remote(cmds)
      user, host = login.split("@")
      
      ssh = ::remoting::Ssh.new(
        :user => user,
        :host => host,
        :interactive => interactive
      )
      
      ssh.exec(cmds)
    end

  end
end