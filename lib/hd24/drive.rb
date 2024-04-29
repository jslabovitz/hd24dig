module HD24

  class Drive

    attr_accessor :path

    include SetParams

    def self.open(path)
      new(path: path).tap(&:read)
    end

    def read
      @fs = FileSystem.open(@path, dump: true)
      @superblock = @fs.read_sector(0, as: Records::Superblock)
      @drive_info = @fs.read_sector(1, as: Records::DriveInfo)
    end

    def show
      # ;;pp self
      ;;pp(projects:)
    end

    def projects
      @drive_info.sector_pointers_to_all_projects.reject(&:zero?).map do |project_sector|
        project_info = @fs.read_sector(project_sector, as: Records::ProjectInfo)
# ;;pp(project_info:)
        songs = project_info.song_info_table.reject(&:zero?).map do |song_sector|
          song_info = @fs.read_sector(song_sector, count: 2, as: Records::SongInfo)
# ;;pp(song_info:)
          # file_allocation_table = @fs.read_sector(song_sector + 2, count: 3, as: Records::FileAllocationTable)
          {
            name: song_info.song_name,
            sample_rate: song_info.sample_rate,
            bit_depth: song_info.bit_depth,
            num_tracks: song_info.num_tracks,
            num_samples: song_info.num_samples,
          }
        end
        {
          name: project_info.project_name,
          songs: songs,
        }
      end
    end

  end

end