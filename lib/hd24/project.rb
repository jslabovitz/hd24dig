module HD24

  class Project < Part

    attr_accessor :num
    attr_accessor :drive

    def name
      @project_info.project_name
    end

    def songs
      @songs ||= @project_info.song_info_sectors.each_with_index.map do |song_sector, song_idx|
        Song.read(fs: @fs, sector: song_sector, num: song_idx + 1, project: self)
      end
    end

    def read
      @project_info = read_record(Records::ProjectInfo, @sector)
      @sector_range = @sector..@sector
    end

    def each_used_sector_range(&block)
      yield(@sector_range)
      songs.each do |song|
        song.each_used_sector_range(&block)
      end
    end

  end

end