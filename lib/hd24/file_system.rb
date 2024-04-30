class HD24

  class FileSystem

    attr_accessor :file

    SECTOR_SIZE = 512
    DUMP_PRINTABLE_BYTES = 32..127

    include SetParams

    def self.open(path, **params)
      new(file: File.open(path), **params)
    end

    def read_sector(num, count: 1, as: nil, dump: false)
      @file.seek(num * SECTOR_SIZE)
      sectors = count.times.map { |i|
        @file.read(SECTOR_SIZE).tap do |sector|
          dump_sector(sector, num: num + i, label: as&.to_s.split('::').last) if dump
        end
      }
      as ? as.read(sectors.join) : sectors
    end

    def dump_sector(sector, num:, label:)
      puts
      0.step(by: 4, to: SECTOR_SIZE - 1) do |offset|
        chunk = sector[offset, 4]
        words = chunk.unpack('L*')
        bytes = chunk.bytes
        puts '%7d | 0x%05x         %-10s         + 0x%04x          > %s      %s      %s      %s      %s' % [
          num,
          num,
          label,
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