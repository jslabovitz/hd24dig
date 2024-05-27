module HD24Dig

  class Drive < Part

    ATTRS = %i[
      projects
    ]
    attr_accessor *ATTRS

    def self.open(path, clone: nil)
      fs = FileSystem.new(file: path, clone:)
      read(fs:, sector: 0)
    end

    def initialize(**)
      @projects = []
      super
    end

    def comparable_attributes
      super + ATTRS
    end

    def inspectable_attributes
      super + ATTRS
    end

    def projects=(projects)
      @projects = []
      projects.each { |p| add_project(p) }
    end

    def add_project(project)
      project.num = @projects.length + 1
      project.drive = self
      @projects << project
    end

    INFO_HEADER = {
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
            full_name,
            project.full_name,
            song.full_name,
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

    def extract_audio(dir: nil, project_nums: nil, song_nums: nil)
      @projects.each do |project|
        if project_nums.nil? || project_nums.include?(project.num)
          project.songs.each do |song|
            if song_nums.nil? || song_nums.include?(song.num)
              song.extract_audio(dir:)
            end
          end
        end
      end
    end

    def clone
      @projects.each do |project|
        project.songs.each do |song|
          song.extract_audio(dir: nil)
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
    end

    def read_drive_info(sector)
      drive_info = read_record(Records::DriveInfo, sector:)
      @name = drive_info.drive_name
      drive_info.sectors_of_projects.reject(&:zero?).each do |project_sector|
        add_project(Project.read(fs: @fs, sector: project_sector))
      end
    end

  end

end