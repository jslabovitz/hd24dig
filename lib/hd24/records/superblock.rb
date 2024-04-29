module HD24

  module Records

    class Superblock < BinData::Record

      endian :little

      # Offset 0x00-0x0f  Header line:
      string :header, length: 16
      # 0x10-0x13 (4):  Size of audio block (0x480)
      uint32le :audio_block_size
      # 0x14-0x17 (4):  Number of audio blocks per allocation cluster
      uint32 :audio_blocks_per_allocation_cluster
      # 0x18-0x1f (8):  0 ?
      uint32
      uint32
      # 0x20-0x23 (4):  0 ?
      uint32
      # 0x24-0x27 (4):  0 ?
      uint32
      # 0x28-0x2b (4):  1 ? sectors in superblock?
      uint32 :sectors_in_superblock
      # 0x2c-0x2f (4):  1 ? sectors in drive info block
      uint32 :sectors_in_drive_info_block
      # 0x30-0x33 (4):  2 ? sectornum of song entry usage table?
      uint32 :sector_num_of_song_entry_usage_table
      # 0x34-0x37 (4):  3 ? sectors in song entry usage table?
      uint32 :sector_in_song_entry_usage_table
      # 0x38-0x3b (4):  5 ? sectornum containing allocation info?
      uint32 :sector_num_of_allocation_info
      # 0x3c-0x3f (4):  15/0fh  - Number of sectors in allocation table?
      uint32 :num_sectors_in_allocation_table
      # 0x40-0x43 (4):  042fh=1071 - total amount of cluster words in allocation table?
      uint32 :total_cluster_words_in_allocation_table
      # 0x44-0x47 (4):  Number of free audio clusters on disk
      uint32 :free_audio_clusters
      # 0x48-0x4b (4):  SectorPointer to project info
      uint32 :sector_pointer_to_project_info
      # 0x4c-0x4f (4):  1
      uint32
      # 0x50-0x53 (4):  Max allowed no. of projects?
      uint32 :max_allowed_projects
      # 0x54-0x57 (4):  Max allowed no. of songs per project?
      uint32 :max_allowed_songs_per_project
      # 0x58-0x5b (4):  SectorPointer to first song info entry
      uint32 :sector_pointer_to_first_song_info_entry
      # 0x5c-0x5f (4):  2 (sectors of song info entry w/o alloc info?)
      uint32 :sectors_of_song_info_entry_without_alloc_info
      # 0x60-0x63 (4):  5 (sectors of alloc info per song entry?)
      uint32 :sectors_of_alloc_info_per_song_entry
      # 0x64-0x67 (4):  7 (number of sectors that song info entries are apart?)
      uint32 :num_sectors_that_song_info_entries_are_apart
      # 0x68-0x6b (4):    current number of songs on disk
      uint32 :current_num_songs
      # 0x78-0x7b (4):  041fh (number of audio blocks reserved for undo buffer).
      uint32 :num_audio_blocks_reserved_for_undo_buffer
      # 0x7c-0x7f (4):  Sector pointer to audio data block on disk (0x1397f6).
      uint32 :sector_pointer_to_audio_data_block
      # 0x80-0x83 (4):  32-bit word
      uint32 :num_allocatable_sectors
      # 0x84-0x87 (4):  32-bit word, highest sector number on disk.
      uint32 :highest_sector_number

    end

  end

end