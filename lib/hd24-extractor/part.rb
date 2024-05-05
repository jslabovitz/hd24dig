class HD24Extractor

  class Part

    attr_accessor :fs   # file system
    attr_accessor :sector
    attr_accessor :sector_range

    include SetParams
    include Simple::Printer::Printable

    def self.read(**params)
      new(**params).tap(&:read)
    end

    def read
      raise NotImplementedError
    end

  end

end