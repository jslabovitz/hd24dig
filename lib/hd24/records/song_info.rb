module HD24

  module Records

    class SongInfo < BinData::Record

      endian :big

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
      # skip to_abs_offset: 0x28
      # skip length: 8

      # # 0x30 +1    ?
      # uint8

      # Offset 31h    Number of physical tracks used by song.
      skip to_abs_offset: 0x31
      uint8 :num_tracks

      # 0x32 +2    Two more filename characters for short filename, used in obsolete FST 1.0 standard.
      # skip length: 2

      # 0x34 +3    Sample rate in samples/second
      #               Typical values are:
      #                 [0x00, 0xac, 0x44] / [0, 172,  68] -> 44100 Samples/sec
      #                 [0x00, 0xbb, 0x80] / [0, 187, 128] -> 48000 Samples/sec
      #                 [0x01, 0x58, 0x88] / [1,  88, 136] -> 88200 Samoles/sec
      #                 [0x01, 0x77, 0x00] / [1, 119,   0] -> 96000 Samples/sec

      # from Claude Opus:
      #
      #   So, the numbers are being represented in a mixed-radix system with
      #   bases [65536, 256, 1], where the coefficients of the powers of
      #   these bases are stored in the representation array [a0,a1,a2].
      #
      #   To convert a set of three numbers [a0,a1,a2] back to the whole
      #   integer N in the mixed-radix system with bases [65536, 256, 1], you
      #   can use the following formula:
      #
      #     N = a0 × 65536 + a1 × 256 + a2

      skip to_abs_offset: 0x34
      array :sample_info, type: :uint8, initial_length: 4

      # # 0x37 +1    Bit depth (18h or 24 by default)
      # skip to_abs_offset: 0x37
      # uint8 :bit_depth

      virtual :sample_rate, value: -> {
        a0, a1, a2 = sample_info[0..2]
        (a0 * 65536) + (a1 * 256) + a2
      }

      virtual :sample_depth, value: -> {
        sample_info[3]
      }

      # 0x38 +4    Unsigned 32-bit number containing number of samples in song.
      skip to_abs_offset: 0x38
      uint32 :num_samples

      # 0x3c +1    Write protect byte.
      uint8 :write_protect

      # 0x58 +96    Track slip info for track 1-24
      skip to_abs_offset: 0x58
      skip length: 96

      # 0xb8 +300  Locate point block
      skip length: 300

      # 0x3b8 +64  Full song name, max 64 bytes; terminated by null byte when less than 64 bytes
      skip to_abs_offset: 0x3b8
      stringz :song_name, length: 64

    end

  end

end