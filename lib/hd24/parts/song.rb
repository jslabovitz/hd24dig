class HD24

  module Parts

    class Song < Part

      attr_accessor :num
      attr_accessor :project

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
          :duration,
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
        t = @song_info.num_tracks
        t /= 2 if high_resolution?
        t
      end

      def duration_secs
        secs = @song_info.num_samples.to_f / sample_rate
        secs *= 2 if high_resolution?
        secs
      end

      def duration
        Duration.from_seconds(duration_secs)
      end

      def audio_blocks
        @file_allocation_info.file_allocation_blocks.reject { |info| info.num_audio_blocks == 0 }.map do |info|
          [info.starting_sector_for_audio_block, info.num_audio_blocks]
        end
      end

      def audio_block_size
        @project.drive.audio_block_size
      end

      def sub_block_size
        audio_block_size / num_tracks
      end

      def track_size
        audio_blocks.map do |starting_sector, num_blocks|
          num_blocks * sub_block_size * SECTOR_SIZE
        end.sum
      end

      def high_resolution?
        sample_rate > 48000
      end

      def extract_audio(dir, show_progress: false)
;;STDERR.print "converting #{name} [\##{num}]: " if show_progress
        raise "Directory #{dir.to_s.inspect} exists!" if dir.exist?
        dir.mkpath
        tracks = make_tracks(dir)
        audio_blocks.each do |starting_sector, num_blocks|
          fs.seek(starting_sector)
          num_blocks.times do |block_num|
;;STDERR.print '*' if show_progress
            tracks.values.each do |io|
;;STDERR.print '.' if show_progress
              data = fs.read(count: sub_block_size, flip: false)
              io.write(data)
            end
          end
        end
;;STDERR.puts if show_progress
        tracks.values.each(&:close)
        tracks.keys
      end

      def make_tracks(dir)
        num_tracks.times.map { |i|
          path = dir / ('Track %02d.wav' % (i + 1))
          io = path.open('wb')
          io.write(wav_header(sample_rate:, data_size: track_size))
          [path, io]
        }.to_h
      end

      def wav_header(sample_rate:, data_size:)
        file_size = data_size + 44   # total file size
        fmt_size = 16
        audio_format = 1  # PCM
        num_channels = 1
        byte_rate = sample_rate * num_channels * 3
        block_align = num_channels * 3
        bits_per_sample = 24
        [
          # RIFF header
          [
            'RIFF',
            [file_size].pack('V'),
            'WAVE',
          ],
          # fmt subchunk
          [
            'fmt ',
            [fmt_size].pack('V'),
            [audio_format].pack('v'),
            [num_channels].pack('v'),
            [sample_rate].pack('V'),
            [byte_rate].pack('V'),
            [block_align].pack('v'),
            [bits_per_sample].pack('v'),
          ],
          # data subchunk
          [
            'data',
            [data_size].pack('V'),
          ],
        ].join
      end

      def read(sector:)
        @song_info = @fs.read(sector: sector, count: 2, as: Records::SongInfo)
# ;;pp(song_info: @song_info)
        @file_allocation_info = @fs.read(sector: sector + 2, count: 3, as: Records::FileAllocationInfo)
# ;;pp(file_allocation_info: @file_allocation_info)
      end

    end

  end
end