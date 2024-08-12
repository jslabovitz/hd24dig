class Path

  def actual_size
    stat.blksize * stat.blocks
  end

end