module HD24

  module Records

    class SongInfo < BinData::Record

      endian :little

      # Offset 00h-03h    32-bit number indicating no. of audio blocks in song
      uint32 :num_audio_blocks
      # Offset 04h-07h    ?0
      uint32
      # Offset 08h-0bh    1/512th of the number of samples per interlace block before the audio switches to the next track.
      uint32 :samples_per_block_512
      # Offset 0ch-0fh    number of sectors per interlace block before the audio switches to the next track.
      uint32 :sectors_per_block
      # Offset 10h-13h    The value stored at offset 08, times 512 (0x200).
      uint32 :samples_per_block
      # Offset 28h-2Fh    First 8 bytes of song name. (obsolete)
      skip length: 8
      # Offset 30h    ?
      uint8
      # Offset 31h    Number of physical tracks used by song.
      uint8 :num_tracks
      # Offset 32h-33h    Two more filename characters for short filename, used in obsolete FST 1.0 standard.
      skip length: 2
      # Offset 34h-36h    Sample rate in samples/second
      array :sample_rate, type: :uint8, initial_length: 3
      # Offset 37h    Bit depth (18h or 24 by default)
      uint8 :bit_depth
      # Offset 38h-3bh    Unsigned 32-bit number containing number of samples in song.
      uint32 :num_samples
      # Offset 3ch    Write protect byte.
      uint8 :write_protect
      # Offset 0x58-0xb7 (96)    Track slip info for track 1-24
      skip length: 96
      # Offset 0xb8-0x1e3 (300)  Locate point block
      skip length: 300
      # Offset 0x3b8-0x3e7 (48)  Full song name, max 64 bytes; terminated by null byte when less than 64 bytes
      stringz :song_name

    end

  end

end