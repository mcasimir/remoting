require 'remote/commander'
require 'remote/ssh'

module Remote
  class RemoteCommander < Commander
    
    attr_reader :login
    def initialize(login)
      @login = login
    end
    
    #overrides
    def do_exec(cmds)
      remote(cmds)
    end
       
    def remote(*cmds)
      opts = cmds.extract_options!
      keep_alive = opts[:keep_alive]
      user, host = login.split("@")
      
      ssh = ::Remote::Ssh.new(
        :user => user,
        :host => host,
        :keep_alive => keep_alive
      )
      
      ssh.exec(cmds)

    end

  end
end