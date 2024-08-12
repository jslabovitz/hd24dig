module HD24Dig

  class FileSystem

    attr_accessor :file
    attr_accessor :copy_file

    SECTOR_SIZE = 512

    include SetParams

    def initialize(**params)
      super
      @io = @file.open('rb')
      @copy_io = @copy_file&.open('wb')
    end

    def read_sectors(count=1)
      pos = @io.tell
      @io.read(count * SECTOR_SIZE).tap do |data|
        if @copy_io
          @copy_io.seek(pos)
          @copy_io.write(data) unless data.all_zeros?
        end
      end
    end

    def seek_sector(sector)
      @io.seek(sector * SECTOR_SIZE)
    end

  end

end