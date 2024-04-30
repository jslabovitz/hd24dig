class HD24

  module Records

    class SongInfo < BinData::Record

      endian :little

      # 0x00 +4    32-bit number indicating no. of audio blocks in song
      uint32 :num_audio_blocks
      # 0x04 +4    ?0
      uint32
      # 0x08 +4    1/512th of the number of samples per interlace block before the audio switches to the next track.
      uint32 :samples_per_block_512
      # 0x0c +4    number of sectors per interlace block before the audio switches to the next track.
      uint32 :num_sectors_per_block
      # 0x10 +4    The value stored at offset 08, times 512 (0x200).
      uint32 :samples_per_block
      # 0x28 +8    First 8 bytes of song name. (obsolete)
      skip length: 8
      # 0x30 +1    ?
      uint8
      # Offset 31h    Number of physical tracks used by song.
      uint8 :num_tracks
      # 0x32 +2    Two more filename characters for short filename, used in obsolete FST 1.0 standard.
      skip length: 2
      # 0x34 +3    Sample rate in samples/second
      array :sample_rate, type: :uint8, initial_length: 3
      # 0x37 +1    Bit depth (18h or 24 by default)
      uint8 :bit_depth
      # 0x38 +4    Unsigned 32-bit number containing number of samples in song.
      uint32 :num_samples
      # 0x3c +1    Write protect byte.
      uint8 :write_protect
      # 0x58 +96    Track slip info for track 1-24
      skip length: 96
      # 0xb8 +300  Locate point block
      skip length: 300
      # 0x3b8 +64  Full song name, max 64 bytes; terminated by null byte when less than 64 bytes
      stringh :song_name, length: 64

    end

  end

end