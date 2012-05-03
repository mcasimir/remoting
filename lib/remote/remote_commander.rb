require 'remote/commander'
require 'remote/ssh'

module Remote
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
      
      ssh = ::Remote::Ssh.new(
        :user => user,
        :host => host,
        :interactive => interactive
      )
      
      ssh.exec(cmds)

    end

  end
end