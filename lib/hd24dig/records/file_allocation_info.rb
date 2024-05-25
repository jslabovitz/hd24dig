module HD24Dig

  module Records

    class FileAllocationBlock < BinData::Record

      endian :big

      # Offset 00h-03h  Starting sector number for audio block
      uint32 :starting_sector

      # Offset 04h-07h  Number of audio blocks in allocation block
      uint32 :num_blocks

    end

    class FileAllocationInfo < BinData::Record

      endian :big

      array :file_allocation_blocks, type: :file_allocation_block, initial_length: 192

      virtual :file_allocation_block_ranges, value: -> {
        file_allocation_blocks.
          reject { |info| info.num_blocks == 0 }.
          map { |info| info.starting_sector .. (info.starting_sector + info.num_blocks - 1) }
      }
    end

  end

end