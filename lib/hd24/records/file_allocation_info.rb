class HD24

  module Records

    class FileAllocationBlock < BinData::Record

      endian :big

      # Offset 00h-03h  Starting sector number for audio block
      uint32 :starting_sector_for_audio_block

      # Offset 04h-07h  Number of audio blocks in allocation block
      uint32 :num_audio_blocks

    end

    class FileAllocationInfo < BinData::Record

      endian :big

      array :file_allocation_blocks, type: :file_allocation_block, initial_length: 192

    end

  end

end