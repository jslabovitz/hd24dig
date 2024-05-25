module HD24Dig

  class Song < Part

    ATTRS = %i[
      num
      name
      sample_rate
      sample_depth
      duration
      num_tracks
    ]
    attr_accessor *ATTRS

    attr_accessor :project

    def duration=(duration)
      @duration = case duration
      when Duration
        duration
      when Array
        Duration.from_array(duration)
      when String
        Duration.from_string(duration)
      else
        raise ArgumentError
      end
    end

    def full_name_elements
      @full_name_elements ||= [project.drive.name, project.name, name]
    end

    def full_name
      @full_name ||= full_name_elements.join(' / ')
    end

    def resolution
      '%d/%d' % [sample_depth, sample_rate / 1000]
    end

    def high_resolution?
      @sample_rate > 48000
    end

    def extract_audio(dir:, extension: nil, &block)
      dir.mkpath
      pcm_files = make_track_paths(dir:, extension: '.pcm')
      pcm_ios = pcm_files.map { |p|
        p.dirname.mkpath
        p.open('wb')
      }
      extract_tracks(pcm_ios, &block)
      pcm_ios.each(&:close)
      converted_files = convert_pcm_files(pcm_files, dir:, extension:, &block)
      pcm_files.map(&:unlink)
      converted_files
    end

    def make_track_paths(dir:, extension: nil)
      @num_tracks.times.map do |track|
        if high_resolution?
          2.times.map do |subtrack|
            path_for_track(track, dir:, subtrack:, extension:)
          end
        else
          path_for_track(track, dir:, extension:)
        end
      end.flatten
    end

    def path_for_track(track, dir:, subtrack: nil, extension: nil)
      file = 'Track %02d%s' % [
        track + 1,
        subtrack ? ('-%d' % (subtrack + 1)) : '',
      ]
      path = dir.join(@project.drive.name, @project.name, '%02d - %s' % [@num, @name], file)
      path.add_extension(extension || '.wav')
    end

    def extract_tracks(track_ios)
      samples_to_read = @num_samples
      @block_ranges.each do |block_range|
        fs.seek_sector(block_range.begin)
        block_range.count.times do
          sub_block_samples = [samples_to_read, @num_samples_per_sub_block].min
          sub_block_bytes = sub_block_samples * 3
          track_ios.each do |track_io|
            data = fs.read_sectors(@num_sectors_per_sub_block)
            track_io.write(data[0, sub_block_bytes]) if track_io
          end
          samples_to_read -= sub_block_samples
        end
      end
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

    def convert_pcm_files(pcm_files, dir:, extension:)
      @num_tracks.times.map do |track|
        converted_file = path_for_track(track, dir:, extension:)
        cmd = ['sox']
        if high_resolution?
          cmd += [
            '--combine', 'merge',
          ]
          pcm_files[track, 2].each do |pcm_file|
            cmd += [
              sox_input_arguments(rate: @sample_rate / 2),
              pcm_file,
            ]
          end
        else
          cmd += [
            sox_input_arguments(rate: @sample_rate),
            pcm_files[track],
          ]
        end
        cmd += [
          '--rate', @sample_rate,
          '--channels', 1,
        ]
        cmd << converted_file
        HD24Dig.run_command(cmd)
        converted_file
      end
    end

    private

    def read(sector)
      song_info = read_record(Records::SongInfo, sector:, count: 2)
;;pp(song_info:)
      @name = song_info.song_name
      @sample_rate = song_info.sample_rate
      @sample_depth = song_info.sample_depth
      @num_samples = song_info.num_samples
      secs = @num_samples.to_f / @sample_rate
      secs *= 2 if high_resolution?
      @duration = Duration.from_seconds(secs)
      @num_actual_tracks = song_info.num_tracks
      @num_tracks = high_resolution? ? (@num_actual_tracks / 2) : @num_actual_tracks
      file_allocation_info = read_record(Records::FileAllocationInfo, sector: sector + 2, count: 5)
      @block_ranges = file_allocation_info.file_allocation_block_ranges
      @num_sectors_per_sub_block = song_info.num_sectors_per_sub_block
      @num_samples_per_sub_block = song_info.num_samples_per_sub_block
    end

  end

end