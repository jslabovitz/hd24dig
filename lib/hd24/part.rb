class HD24

  class Part

    attr_accessor :fs   # file system

    include SetParams
    include Simple::Printer::Printable

    def self.read(sector:, **params)
      new(**params).tap { |o| o.read(sector:) }
    end

    def read(sector:)
      raise NotImplementedError
    end

  end

end