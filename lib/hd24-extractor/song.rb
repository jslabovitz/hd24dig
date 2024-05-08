module HD24Extractor

  class Song < Part

    attr_accessor :num
    attr_accessor :project

    def printable
      [
        [:num, 'Number'],
        :name,
        :resolution,
        :num_effective_tracks,
        :duration,
      ]
    end

    def name
      @song_info.song_name
    end

    def full_name_elements
      @full_name_elements ||= [project.drive.name, project.name, name]
    end

    def full_name
      @full_name ||= full_name_elements.join(' / ')
    end

    def sample_rate
      @sample_rate ||= @song_info.sample_rate
    end

    def sample_rate_str
      rate = sample_rate / 1000.0
      (rate == rate.to_i) ? rate.to_i.to_s : ('%.1f' % rate)
    end

    def resolution_str
      '%d/%s' % [sample_depth, sample_rate_str]
    end

    def sample_depth
      @sample_depth ||= @song_info.sample_depth
    end

    def num_actual_tracks
      @song_info.num_tracks
    end

    def num_effective_tracks
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
      @duration ||= Duration.from_seconds(duration_secs)
    end

    def audio_blocks
      @audio_blocks ||= @file_allocation_info.file_allocation_blocks.reject { |info| info.num_audio_blocks == 0 }.map do |info|
        [info.starting_sector_for_audio_block, info.num_audio_blocks]
      end
    end

    def audio_block_size
      @project.drive.audio_block_size
    end

    def sub_block_size
      @sub_block_size ||= audio_block_size / num_actual_tracks
    end

    def total_blocks
      @total_blocks ||= audio_blocks.map { |s, b| b }.sum
    end

    def high_resolution?
      sample_rate > 48000
    end

    def extract_audio(dir, extension: '.wav', &block)
      pcm_files = make_track_paths(dir:, extension: '.pcm')
      extract_tracks(pcm_files) do
        yield(:extracting) if block_given?
      end
      converted_files = convert_pcm_files(pcm_files, dir:, extension:) do
        yield(:converting) if block_given?
      end
      pcm_files.map(&:unlink)
      converted_files
    end

    def total_extraction_steps
      total_blocks + num_effective_tracks
    end

    def make_track_paths(dir:, extension:)
      num_effective_tracks.times.map do |track|
        if high_resolution?
          2.times.map do |subtrack|
            make_track_path(dir:, track:, subtrack:, extension:)
          end
        else
          make_track_path(dir:, track:, extension:)
        end
      end.flatten
    end

    def make_track_path(dir:, track:, subtrack: nil, extension:)
      (dir / (
        'Track %02d%s' % [
          track + 1,
          subtrack ? ('-%d' % (subtrack + 1)) : '',
        ]
      )).add_extension(extension)
    end

    def extract_tracks(pcm_files, &block)
      pcm_ios = pcm_files.map { |p| p.open('wb') }
      audio_blocks.each do |starting_sector, num_blocks|
        fs.seek_sector(starting_sector)
        num_blocks.times do |block_num|
          pcm_ios.each do |pcm_io|
            pcm_io.write(fs.read_sectors(sub_block_size))
          end
          yield(starting_sector, block_num) if block_given?
        end
      end
      pcm_ios.each(&:close)
    end

    def sox_input_arguments(rate:)
      [
        '--type', 'raw',
        '--rate', rate,
        '--bits', 24,
        '--encoding', 'signed-integer',
        '--channels', 1,
      ]
    end

    def convert_pcm_files(pcm_files, dir:, extension:, &block)
      num_effective_tracks.times.map do |track|
        converted_file = make_track_path(dir:, track:, extension:)
        cmd = ['sox']
        if high_resolution?
          cmd += [
            '--combine', 'merge',
          ]
          pcm_files[track, 2].each do |pcm_file|
            cmd += [
              sox_input_arguments(rate: sample_rate / 2),
              pcm_file,
            ]
          end
        else
          cmd += [
            sox_input_arguments(rate: sample_rate),
            pcm_files[track],
          ]
        end
        cmd += [
          '--rate', sample_rate,
          '--channels', 1,
        ]
        cmd << converted_file
        cmd = cmd.flatten.compact.map(&:to_s)
        # ;;warn cmd.join(' ')
        command = TTY::Command.new(printer: :null)
        command.run(*cmd)
        yield if block_given?
        converted_file
      end
    end

    def read
      range1 = @sector..(@sector + 1)
      @song_info = read_record(Records::SongInfo, range1)
# ;;pp(song_info: @song_info)

      range2 = (@sector + 2) .. (@sector + 2 + 5)
      @file_allocation_info = read_record(Records::FileAllocationInfo, range2)
# ;;pp(file_allocation_info: @file_allocation_info)

      @sector_range = range1.begin..range2.end
    end

    def each_used_sector_range(&block)
      yield(@sector_range)
      audio_blocks.each do |starting_sector, num_blocks|
        yield(starting_sector ... (starting_sector + (num_blocks * sub_block_size)))
      end
    end

  end

end