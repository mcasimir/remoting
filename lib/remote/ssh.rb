require 'net/ssh'
require 'remote/shell'

module Remote
  class Ssh
    attr_reader  :host, :user

    def initialize(*args)
      options = args.extract_options!
      @host, @user, @interactive = options.values_at(:host, :user, :interactive)  
    end


    def shell
      @shell ||= ::Remote::Shell.new
    end
    
    def exec(commands)

      if interactive?
        ssh = %(ssh #{user}@#{host})
        Kernel.exec ssh + %( -t '#{commands.join("; ")}')  # this will replace the current process and will never return the shell back
      else
        Net::SSH.start(host, user) do |ssh|
      
          ssh.open_channel do |channel|
            channel.exec(commands.join(";")) do |ch, success|
              unless success
                abort
              end
            
              channel.on_data do |ch, data|
                say "#{data}"
              end

              channel.on_extended_data do |ch, type, data|
                shell.error "#{data}"
              end

              channel.on_close do |ch|
                shell.bold "channel is closing!\n"
              end
            end
          end

          ssh.loop 
        end        
      end
  
    end # ~ exec
        
    def interactive?
      !!@interactive
    end

  end
end
