require 'thor'

class Shell < Thor::Shell::Color
  def ask_password(*args)
    system "stty -echo" 
    res = ask(*args)
    system "stty echo"
    puts("\n") 
    res
  end
  
  def continue?(message)
    res = yes?(message << " (y/yes)")
    if !res
      say("Cancelled", BLUE)
    end
    res
  end
  
  def bold(message)
    say(message, BOLD)
  end
  
  def no?(message)
    super(message << " (n/no)")
  end
    
  def success(message)
    say(message, GREEN)
  end
  
  def error(message)
    say(message, RED)
  end
end
