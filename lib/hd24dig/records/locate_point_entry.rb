module HD24Dig

  module Records

    class LocatePointEntry < BinData::Record

      endian :big

      # Offset 0-3  32-bit time code
      #     The time code represents the sample number
      #     within the song.

      uint32 :time_code

      # Offset 4-11 The 8-byte locate point name

      string :name, length: 8

    end

  end

end