class HD24

  class FileSystem

    attr_accessor :file

    SECTOR_SIZE = 512
    DUMP_PRINTABLE_BYTES = 32..127

    include SetParams

    def self.open(path, **params)
      new(file: File.open(path, 'rb'), **params)
    end

    def read(sector: nil, count: 1, as: nil, dump: false, flip: true)
      seek(sector) if sector
      data = count.times.map { |i|
        sector_data = @file.read(SECTOR_SIZE)
        sector_data = sector_data.unpack('L*').pack('N*') if flip
        dump_sector(sector_data, num: num + i, label: as&.to_s.split('::').last) if dump
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

    def dump_sector(sector, num:, label:)
      puts
      0.step(by: 4, to: SECTOR_SIZE - 1) do |offset|
        chunk = sector[offset, 4]
        words = chunk.unpack('L*')
        bytes = chunk.bytes
        puts '%-10s    %7d | 0x%05x + 0x%04x         %s      %s      %s      %s      %s' % [
          label,
          num,
          num,
          offset,
          words.map { |w| '0x%08x' % w }.join(', '),
          words.map { |w| '%10d' % w }.join(', '),
          bytes.map { |b| '0x%02x' % b }.join(', '),
          bytes.map { |b| '%3d' % b }.join(', '),
          bytes.map { |b| DUMP_PRINTABLE_BYTES.include?(b) ? b.chr : '.' }.join,
        ]
      end
    end

  end

end