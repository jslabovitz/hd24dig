class HD24

  class Part

    include SetParams
    include Simple::Printer::Printable

    def self.read(fs:, sector:, **params)
      new(**params).tap { |o| o.read(fs:, sector:) }
    end

    def read(fs:, sector:)
      raise NotImplementedError
    end

  end

end