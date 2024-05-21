module HD24Dig

  class FileSystem

    attr_accessor :file
    attr_accessor :clone

    SECTOR_SIZE = 512

    include SetParams

    def initialize(**params)
      super
      @io = @file.open('rb')
      @clone_io = @clone&.open('wb')
    end

    def read_sectors(count=1)
      pos = @io.tell
      @io.read(count * SECTOR_SIZE).tap do |data|
        if @clone_io
          @clone_io.seek(pos)
          @clone_io.write(data)
        end
      end
    end

    def seek_sector(sector)
      @io.seek(sector * SECTOR_SIZE)
    end

  end

end