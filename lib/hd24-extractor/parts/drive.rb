class HD24Extractor

  module Parts

    class Drive < Part

      def printable
        [
          :name,
          :projects,
        ]
      end

      def version
        @version ||= @superblock.version.sub(/^(\d)(\d+)/, '\1.\2') or raise UnexpectedData
      end

      def name
        @drive_info.drive_name
      end

      def audio_block_size
        @superblock.audio_block_size
      end

      def projects
        @projects ||= @drive_info.sectors_of_projects.reject(&:zero?).each_with_index.map do |project_sector, project_idx|
          Project.read(fs: @fs, sector: project_sector, num: project_idx + 1, drive: self)
        end
      end

      SUPERBLOCK_VALIDATIONS = {
        header: 'ADAT FST',
        version: '110 ',
        num_sectors_in_superblock: 1,
        num_sectors_in_drive_info_block: 1,
      }

      def read(sector:)
        @superblock = @fs.read(sector: sector, as: Records::Superblock)
# ;;pp(superblock: @superblock)
        SUPERBLOCK_VALIDATIONS.each do |key, value|
          if value != (value2 = @superblock.send(key))
            raise UnexpectedData, "validation failed: expected #{key} = #{value.inspect}, but was #{value2.inspect}"
          end
        end
        @drive_info = @fs.read(sector: 1, as: Records::DriveInfo)
# ;;pp(drive_info: @drive_info)
      end

    end

  end

end