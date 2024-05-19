module HD24Dig

  class Drive < Part

    attr_accessor :name
    attr_accessor :projects
    attr_accessor :audio_block_size

    def self.open(path)
      fs = FileSystem.open(path.to_s, 'rb')
      read(fs:, sector: 0)
    end

    def projects=(projects)
      @projects = projects.each_with_index.map do |p, i|
        p.num = i + 1
        p.drive = self
        p
      end
    end

    def ==(other)
      !other.nil? &&
        @name == other.name &&
        @projects == other.projects
    end

    INFO_HEADER = {
      'project #' => :right,
      'song #' => :right,
      'drive' => :left,
      'project' => :left,
      'song' => :left,
      'duration' => :left,
      'tracks' => :right,
      'resolution' => :left,
    }

    def print_info(output=STDOUT)
      table = TTY::Table.new(header: INFO_HEADER.keys)
      @projects.each do |project|
        project.songs.each do |song|
          table << [
            project.num,
            song.num,
            @name,
            project.name,
            song.name,
            song.duration,
            song.num_tracks,
            song.resolution,
          ]
        end
      end
      output.puts table.render(:unicode,
        padding: [0, 1],
        alignments: INFO_HEADER.values.map { |a| a || :left },
      )
    end

    def extract_audio(dir:, project_nums: nil, song_nums: nil, &block)
      @projects.each do |project|
        if project_nums.nil? || project_nums.include?(project.num)
          project.songs.each do |song|
            if song_nums.nil? || song_nums.include?(song.num)
              song.extract_audio(dir:, &block)
            end
          end
        end
      end
    end

    private

    def read(sector)
      read_superblock(sector)
      read_drive_info(sector + 1)
    end

    SUPERBLOCK_VALIDATIONS = {
      header: 'ADAT FST',
      version: '110 ',
      num_sectors_in_superblock: 1,
      num_sectors_in_drive_info_block: 1,
    }

    def read_superblock(sector)
      superblock = read_record(Records::Superblock, sector:)
      SUPERBLOCK_VALIDATIONS.each do |key, value|
        if value != (value2 = superblock.send(key))
          raise UnexpectedData, "validation failed: expected #{key} = #{value.inspect}, but was #{value2.inspect}"
        end
      end
      @audio_block_size = superblock.audio_block_size
    end

    def read_drive_info(sector)
      drive_info = read_record(Records::DriveInfo, sector:)
      @name = drive_info.drive_name
      @projects = drive_info.sectors_of_projects.reject(&:zero?).each_with_index.map do |project_sector, project_idx|
        Project.read(fs: @fs, sector: project_sector, num: project_idx + 1, drive: self)
      end
    end

  end

end