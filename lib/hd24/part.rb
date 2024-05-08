module HD24

  class Part

    attr_accessor :fs   # file system
    attr_accessor :sector
    attr_accessor :sector_range

    include SetParams

    def self.read(**params)
      new(**params).tap(&:read)
    end

    def sector=(num)
      @sector = num.to_i
    end

    def read
      raise NotImplementedError
    end

    def read_record(klass, sectors)
      sectors = case sectors
      when Numeric
        sectors..sectors
      when Range
        sectors
      else
        raise "Unknown sectors specification: #{sectors.inspect} (#{sectors.class})"
      end
# ;;warn "reading sectors #{sectors.inspect} into #{klass}"
      @fs.seek_sector(sectors.begin)
      klass.read(@fs.read_sectors(sectors.count).unpack('L*').pack('N*'))
    end

  end

end