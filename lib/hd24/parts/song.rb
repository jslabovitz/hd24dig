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

      def high_resolution?
        sample_rate > 48000
      end

      def extract_audio(dir, show_progress: false)
        FileUtils.mkdir_p(dir) unless File.exist?(dir)
        track_paths = num_tracks.times.map do |track|
          File.join(dir, 'Track %02d.pcm' % track)
        end
        track_files = track_paths.map do |path|
          File.open(path, 'wb')
        end
        audio_block_size = @project.drive.audio_block_size
        sub_block_size = audio_block_size / num_tracks
;;STDERR.print "converting #{name} [\##{num}]: " if show_progress
        audio_blocks.each do |starting_sector, num_blocks|
          fs.seek(starting_sector)
          num_blocks.times do |block_num|
;;STDERR.print '*' if show_progress
            num_tracks.times do |track|
;;STDERR.print '.' if show_progress
              data = fs.read(count: sub_block_size, flip: false)
              track_files[track].write(data)
            end
          end
        end
;;STDERR.puts if show_progress
        track_files.each(&:close)
        track_paths.map { |p| convert_pcm_to_wav(p) }
      end

      def convert_pcm_to_wav(pcm_path)
        wav_path = pcm_path.sub(/\.pcm/, '.wav')
        cmd = [
          'sox',
          '-t', 'raw',
          '-r', sample_rate,
          '-b', 24,
          '-e', 'signed-integer',
          pcm_path,
          wav_path,
        ].flatten.compact.map(&:to_s)
        # ;;warn cmd.join(' ')
        system(*cmd)
        File.unlink(pcm_path)
        wav_path
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