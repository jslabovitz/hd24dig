class HD24

  module Parts

    class Song < Part

      def printable
        [
          :name,
          [:resolution, 'Resolution', (
            rate = sample_rate / 1000.0
            rate_str = (rate == rate.to_i) ? rate.to_i.to_s : '%.1f' % rate
            '%s/%d' % [rate_str, sample_depth]
          )],
          :num_tracks,
          [:duration, 'Duration', '%dm%ds' % [duration / 60, duration % 60]],
        ]
      end

      def name
        @song_info.song_name
      end

      def sample_rate
        a0, a1, a2 = @song_info.sample_info[1..3].reverse
        (a0 * 65536) + (a1 * 256) + a2
      end

      def sample_depth
        @song_info.sample_info[0]
      end

      def num_tracks
        @song_info.num_tracks
      end

      def duration
        @song_info.num_samples / sample_rate
      end

      def read(fs:, sector:)
        @song_info = fs.read_sector(sector, count: 2, as: Records::SongInfo, dump: false)
        # file_allocation_table = @fs.read_sector(sector + 2, count: 3, as: Records::FileAllocationTable, dump: true)
      end

    end

  end
end