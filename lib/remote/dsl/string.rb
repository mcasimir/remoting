class String
  def > (arg)
    self << " > " << "#{arg}"  
    arg.clear
    self
  end

  def >> (arg)
    self << " >> " << "#{arg}"  
    arg.clear
    self
  end
  
  def | (arg)
    self << " | " << "#{arg}"  
    arg.clear
    self
  end

  def join(*args)
    Pathname.new(self).join(*args).to_s
  end
  
end
