class HD24

  module Parts

    class Song < Part

      attr_accessor :num

      def printable
        [
          [:num, 'Number'],
          :name,
          [:resolution, 'Resolution', (
            rate = sample_rate / 1000.0
            rate_str = (rate == rate.to_i) ? rate.to_i.to_s : '%.1f' % rate
            '%s/%d' % [rate_str, sample_depth]
          )],
          :num_tracks,
          [:duration, 'Duration', '%dm%ds' % [duration / 60, duration % 60]],
          [:audio_blocks, 'Audio blocks', (
            audio_blocks.map do |sector, num_blocks|
              '%d @ %d' % [num_blocks, sector]
            end.join(', ')
          )],
        ]
      end

      def name
        @song_info.song_name
      end

      def sample_rate
        a0, a1, a2 = @song_info.sample_info[0..2]
        (a0 * 65536) + (a1 * 256) + a2
      end

      def sample_depth
        @song_info.sample_info[3]
      end

      def num_tracks
        @song_info.num_tracks
      end

      def duration
        @song_info.num_samples / sample_rate
      end

      def audio_blocks
        @file_allocation_info.file_allocation_blocks.reject { |info| info.num_audio_blocks == 0 }.map do |info|
          [info.starting_sector_for_audio_block, info.num_audio_blocks]
        end
      end

      def extract_audio(io)
        audio_blocks.each do |sector, num_blocks|
          blocks = fs.read_sector(sector)
          #FIXME
        end
      end

      def read(sector:)
        @song_info = @fs.read_sector(sector, count: 2, as: Records::SongInfo, dump: false)
# ;;pp(song_info: @song_info)
        @file_allocation_info = @fs.read_sector(sector + 2, count: 3, as: Records::FileAllocationInfo, dump: false)
# ;;pp(file_allocation_info: @file_allocation_info)
      end

    end

  end
end