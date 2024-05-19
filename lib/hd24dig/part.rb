module HD24Dig

  class Part

    attr_accessor :fs   # file system

    include SetParams

    def self.read(sector:, **params)
      new(**params).tap { |p| p.send(:read, sector) }
    end

    private

    def read(sector)
      raise NotImplementedError
    end

    def read_record(klass, sector:, count: 1)
# ;;warn "reading #{sectors} sectors @ #{sector} into #{klass}"
      @fs.seek_sector(sector)
      klass.read(@fs.read_sectors(count).unpack('L*').pack('N*'))
    end

  end

end