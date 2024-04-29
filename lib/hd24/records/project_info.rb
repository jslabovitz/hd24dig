module HD24

  module Records

    class ProjectInfo < BinData::Record

      endian :little

      # 0x00 + 4  8-byte project name (obsolete)
      # 0x08 + 4-byte (2 bytes of which are partial project name too)
      uint32
      uint32
      uint32
      # 0x0c-0x0f  Number of songs in use in project
      uint32 :num_songs

      # offset 10h-19bh Song info table (a list of initial sectors of song info).
      #     Length of table should be 396 bytes for 99 songs per project.
      #     First entry in the table is the last accessed song.
      #     Zero char means unused entry.
      array :song_info_table, type: :uint32, initial_length: 99

      # Offset 01b8h  64-byte project name. Null-byte terminated if project name is less than 64 bytes long.
      stringz :project_name, initial_length: 64

    end

  end

end