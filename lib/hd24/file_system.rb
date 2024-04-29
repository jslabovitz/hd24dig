module HD24

  class FileSystem

    attr_accessor :file
    attr_accessor :dump

    SECTOR_SIZE = 512

    include SetParams

    def self.open(path, **params)
      new(file: File.open(path), **params)
    end

    def read_sector(num, count: 1, as: nil)
      @file.seek(num * SECTOR_SIZE)
      sectors = count.times.map { |i|
        Sector.new(data: @file.read(SECTOR_SIZE), num: num + i, label: as.to_s.split('::').last)
      }
      result = as ? as.read(sectors.map(&:data).join) : sectors
      if @dump
        sectors.each(&:dump)
        pp(result.class => result)
      end
      result
    end

    class Sector

      attr_accessor :data
      attr_accessor :num
      attr_accessor :label

      include SetParams

      WORDS_PER_LINE = 8 * 2
      PRINTABLE_BYTES = 32..127

      def dump(io=STDOUT)
        io.puts
        io.puts "--- sector: #{@num}, label: #{@label || '-'}"
        0.step(by: WORDS_PER_LINE, to: SECTOR_SIZE - 1) do |offset|
          io.print '%04x: ' % offset
          chunk = @data[offset, WORDS_PER_LINE]
          chunk.unpack('L*').each do |word|
            io.print '%08x ' % word
          end
          io.print ' | '
          chunk.unpack('L*').each do |word|
            io.print '%10d ' % word
          end
          io.print ' | '
          chunk.bytes.each do |byte|
            io.print '%s' % (PRINTABLE_BYTES.include?(byte) ? byte.chr : '.')
          end
          # io.print chunk.inspect
          io.puts
        end
      end

    end

  end

end