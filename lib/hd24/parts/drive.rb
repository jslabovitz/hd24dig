class HD24

  module Parts

    class Drive < Part

      attr_accessor :projects

      def printable
        [
          :version,
          :name,
          [:num_songs, 'Songs'],
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

      def read(fs:, sector:)
        @superblock = fs.read_sector(sector, as: Records::Superblock, dump: false)
  # ;;pp(superblock: @superblock)
        raise UnexpectedData unless @superblock.header == 'ADAT FST'
        raise UnexpectedData unless @superblock.num_sectors_in_superblock == 1
        raise UnexpectedData unless @superblock.num_sectors_in_drive_info_block == 1
        @drive_info = fs.read_sector(1, as: Records::DriveInfo, dump: false)
  # ;;pp(drive_info: @drive_info)
        @projects = @drive_info.sectors_of_projects.reject(&:zero?).map do |project_sector|
          Project.read(fs: fs, sector: project_sector)
        end
      end

    end

  end

end