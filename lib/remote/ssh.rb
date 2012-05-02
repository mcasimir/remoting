require 'termios'
require 'net/ssh'

class Ssh
  attr_reader :keep_alive, :host, :user

  def initialize(*args)
    options = args.extract_options!
    @host, @user, @keep_alive = options.values_at(:host, :user, :keep_alive)    
    @keep_alive = !!@keep_alive
  end

  def stdin_buffer( enable )
    return unless defined?( Termios )
    attr = Termios::getattr( $stdin )
    if enable
      attr.c_lflag |= Termios::ICANON | Termios::ECHO
    else
      attr.c_lflag &= ~(Termios::ICANON|Termios::ECHO)
    end
    Termios::setattr( $stdin, Termios::TCSANOW, attr )
  end

  def exec(commands)
    if !keep_alive
      commands << 'exit'
    end
    Net::SSH.start( host, user ) do |session|

     begin
        stdin_buffer false

        shell = session.shell.open( :pty => true )
        
        commands.each do |command|
          break unless shell.open?
          shell.execute
        end
        
        loop do
          break unless shell.open?
          if IO.select([$stdin],nil,nil,0.01)
            data = $stdin.sysread(1)
            shell.send_data data
          end

          $stdout.print shell.stdout while shell.stdout?
          $stdout.flush
        end
      ensure
        stdin_buffer true
      end

    end
    
  end


end

