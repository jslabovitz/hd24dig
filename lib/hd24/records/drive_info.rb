module HD24

  module Records

    class DriveInfo < BinData::Record

      endian :little

      # 0x00-0x07 (8):  8 byte drive name (for compatibility with older ADAT FST versions),
      #                 should be considered obsolete. Replaced by name at offset 01bh.
      uint32
      uint32
      # 0x08-0x09 (2):  null bytes
      uint16
      # 0x0a-0x0b (2)  2 more bytes for drive name. Should be considered obsolete
      uint16
      # ?
      uint32
      # 0x10-0x13 (4)  SectorPointer to last active project.
      uint32 :sector_of_last_active_project
      # 0x13-0x16 (4)
      uint32
      # 0x16-0x19 (4)
      uint32
      # ? (4)
      uint32
      # 0x20-  List of 32-bit sector pointers to all projects.
      array :sectors_of_projects, type: :uint32, initial_length: 102
      # 0x01b8- (64):  64-byte drive name. Null-byte terminated when shorter than 64 chars.
      stringh :drive_name, length: 64

    end

  end

end