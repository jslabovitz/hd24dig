class HD24

  module Parts

    class Song < Part

      def printable
        [
          :name,
          :sample_rate,
          :bit_depth,
          :num_tracks,
          :num_samples,
        ]
      end

      def name
        @song_info.song_name
      end

      def sample_rate
        @song_info.sample_rate
      end

      def bit_depth
        @song_info.bit_depth
      end

      def num_tracks
        @song_info.num_tracks
      end

      def num_samples
        @song_info.num_samples
      end

      def read(fs:, sector:)
        @song_info = fs.read_sector(sector, count: 2, as: Records::SongInfo, dump: false)
        # file_allocation_table = @fs.read_sector(sector + 2, count: 3, as: Records::FileAllocationTable, dump: true)
      end

    end

  end
end