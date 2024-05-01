class HD24

  class FileSystem

    attr_accessor :file

    SECTOR_SIZE = 512

    include SetParams

    def self.open(path, **params)
      new(file: File.open(path, 'rb'), **params)
    end

    def read(sector: nil, count: 1, as: nil, dump: false, flip: true)
      seek(sector) if sector
      data = count.times.map { |i|
        sector_data = @file.read(SECTOR_SIZE)
        sector_data = sector_data.unpack('L*').pack('N*') if flip
        if dump
          prefix = '%-10s    %7d | 0x%05x ' % [as&.to_s.split('::').last, sector + i, sector + i]
          Simple::Dumper.dump(sector_data, prefix: prefix)
        end
        sector_data
      }.join
      as&.read(data) || data
    end

    def seek(sector)
      @file.seek(sector * SECTOR_SIZE)
    end

    def tell
      @file.tell / SECTOR_SIZE
    end

  end

end