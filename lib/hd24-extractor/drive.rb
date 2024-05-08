module HD24Extractor

  class Drive < Part

    def self.open(path)
      fs = FileSystem.open(path.to_s, 'rb')
      read(fs:, sector: 0)
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

    def clone(to:)
      FileSystem.open(to, 'wb') do |to_fs|
        each_used_sector_range do |sector_range|
          @fs.seek_sector(sector_range.begin)
          to_fs.seek_sector(sector_range.begin)
          to_fs.write(@fs.read_sectors(sector_range.count))
        end
      end
    end

    SUPERBLOCK_VALIDATIONS = {
      header: 'ADAT FST',
      version: '110 ',
      num_sectors_in_superblock: 1,
      num_sectors_in_drive_info_block: 1,
    }

    def read
      @superblock = read_record(Records::Superblock, @sector)
# ;;pp(superblock: @superblock)
      SUPERBLOCK_VALIDATIONS.each do |key, value|
        if value != (value2 = @superblock.send(key))
          raise UnexpectedData, "validation failed: expected #{key} = #{value.inspect}, but was #{value2.inspect}"
        end
      end
      @drive_info = read_record(Records::DriveInfo, @sector + 1)
# ;;pp(drive_info: @drive_info)
      @sector_range = @sector..(@sector + 1)
    end

    def each_used_sector_range(&block)
      yield(@sector_range)
      projects.each do |project|
        project.each_used_sector_range(&block)
      end
    end

  end

end