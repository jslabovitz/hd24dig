module HD24Dig

  class Part

    attr_accessor :fs   # file system

    include SetParams

    def self.read(sector:, **params)
      new(**params).tap { |p| p.send(:read, sector) }
    end

    def inspect
      to_h.inspect
    end

    def to_h
      self.class.const_get(:ATTRS).map { |k| [k, send(k)] }.to_h
    end

    def ==(other)
      to_h == other&.to_h
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