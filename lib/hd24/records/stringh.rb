class HD24

  class Stringh < BinData::Primitive

    string :str, read_length: :length

    def get
      self.str.unpack('N*').pack('L*').gsub(/^([^\0]+).*$/) { $1 }
    end

    # def set(v) self.data = v; end
  end

end