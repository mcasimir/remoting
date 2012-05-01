require 'remote/commander'
require 'net/ssh'

module Remote
  class RemoteCommander < Commander
    
    attr_reader :login
    def initialize(login)
      @login = login
      super
    end
    
    #overrides
    def do_exec(cmds)
      remote(cmds)
    end
    
    def ssh(user_at_host) # eg ssh "usr@remoteserver" do |conn| ...
      user, host = user_at_host.split("@")

      Net::SSH.start(host, user) do |ssh|
        yield(ssh)
      end
    end
    
    def remote(*cmds)
      res = ""
      runline = command_list(cmds).join(";")

      puts "[REMOTE] Executing '#{runline}' ..."
      ssh(login) do |remote|
        puts res = remote.exec!(runline)
      end

      res.split("\n").last if res # latest retval
    end

  end
end