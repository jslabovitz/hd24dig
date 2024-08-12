class String

  def all_zeros?
    each_byte.all? { |byte| byte == 0 }
  end

end