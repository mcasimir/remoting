class Symbol

  def > (arg)
    ["#{self}", "#{arg}"].join(" > ")
  end

  def >> (arg)
    ["#{self}", "#{arg}"].join(" >> ")
  end
  
  def | (arg)
    ["#{self}", "#{arg}"].join(" | ")    
  end
  
end
