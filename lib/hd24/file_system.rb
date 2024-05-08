module HD24

  class FileSystem < File

    SECTOR_SIZE = 512

    def read_sectors(count=1)
      read(count * SECTOR_SIZE)
    end

    def seek_sector(sector)
      seek(sector * SECTOR_SIZE)
    end

  end

end