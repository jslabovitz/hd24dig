class HD24

  module Parts

    class Drive < Part

      attr_accessor :projects

      def printable
        [
          :name,
          :projects,
        ]
      end

      def version
        @superblock.version.sub(/^(\d)(\d+)/, '\1.\2') or raise UnexpectedData
      end

      def name
        @drive_info.drive_name
      end

      def num_songs
        @superblock.num_songs
      end

      def audio_block_size
        @superblock.audio_block_size
      end

      def read(sector:)
        @superblock = @fs.read(sector: sector, as: Records::Superblock)
# ;;pp(superblock: @superblock)
        raise UnexpectedData unless @superblock.header == 'ADAT FST'
        raise UnexpectedData unless @superblock.num_sectors_in_superblock == 1
        raise UnexpectedData unless @superblock.num_sectors_in_drive_info_block == 1
        @drive_info = @fs.read(sector: 1, as: Records::DriveInfo)
# ;;pp(drive_info: @drive_info)
        @projects = @drive_info.sectors_of_projects.reject(&:zero?).each_with_index.map do |project_sector, project_idx|
          Project.read(fs: @fs, sector: project_sector, num: project_idx + 1, drive: self)
        end
      end

    end

  end

end