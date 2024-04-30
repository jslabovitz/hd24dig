module HD24

  module Records

    class ProjectInfo < BinData::Record

      endian :little

      # 0x00 + 8  8-byte project name (obsolete)
      skip length: 8
      # 0x08 + 4  4-byte (2 bytes of which are partial project name too)
      uint32
      # 0x0c-0x0f  Number of songs in use in project
      uint32 :num_songs

      # 0x10-0x019b Song info table (a list of initial sectors of song info).
      #     Length of table should be 396 bytes for 99 songs per project.
      #     First entry in the table is the last accessed song.
      #     Zero char means unused entry.
      array :song_info_table, type: :uint32, initial_length: 99

      skip length: 28

      # 0x01b8-  64-byte project name. Null-byte terminated if project name is less than 64 bytes long.
      stringh :project_name, length: 64

    end

  end

end