module HD24Dig

  class Project < Part

    attr_accessor :name
    attr_accessor :num
    attr_accessor :songs
    attr_accessor :drive

    def songs=(songs)
      @songs = songs.each_with_index.map do |s, i|
        s.num = i + 1
        s.project = self
        s
      end
    end

    def ==(other)
      !other.nil? &&
        @num == other.num &&
        @name == other.name &&
        @songs == other.songs
    end

    def read(sector)
      project_info = read_record(Records::ProjectInfo, sector:)
      @name = project_info.project_name
      @songs = project_info.song_info_sectors.each_with_index.map do |song_sector, song_idx|
        Song.read(fs: @fs, sector: song_sector, num: song_idx + 1, project: self)
      end
    end

  end

end