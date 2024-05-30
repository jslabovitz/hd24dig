module HD24Dig

  class Part

    ATTRS = %i[
      num
      name
    ]
    attr_accessor *ATTRS
    attr_accessor :fs   # file system

    include SetParams

    def self.read(sector:, **params)
      new(**params).tap { |p| p.send(:read, sector) }
    end

    def full_name
      '%s%02d%s' % [self.class.name.split('::').last, @num, @name && " - #{@name}"]
    end

    def ==(other)
      comparable_attributes.each do |key|
        if send(key) != other&.send(key)
;;warn "#{self.class}: #{key.inspect} different: #{send(key)} != #{other&.send(key)}"
          return false
        end
      end
      true
    end

    def comparable_attributes
      ATTRS
    end

    def inspectable_attributes
      ATTRS
    end

    def inspect
      "<#{self.class.name} #{inspectable_attributes.map { |a| [a, send(a)] }.to_h.inspect}"
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