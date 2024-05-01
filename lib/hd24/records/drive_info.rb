class HD24

  module Records

    class DriveInfo < BinData::Record

      endian :big

      # 0x20-  List of 32-bit sector pointers to all projects.
      skip to_abs_offset: 0x20
      array :sectors_of_projects, type: :uint32, initial_length: 102

      # 0x01b8- (64):  64-byte drive name. Null-byte terminated when shorter than 64 chars.
      stringz :drive_name, length: 64

    end

  end

end