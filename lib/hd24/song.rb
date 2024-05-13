module HD24

  class Song < Part

    attr_accessor :num
    attr_accessor :name
    attr_accessor :sample_rate
    attr_accessor :sample_depth
    attr_accessor :duration
    attr_accessor :num_tracks
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

    def ==(other)
      !other.nil? &&
        @num == other.num &&
        @name == other.name &&
        @sample_rate == other.sample_rate &&
        @sample_depth == other.sample_depth &&
        @duration == other.duration &&
        @num_tracks == other.num_tracks
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

    def extract_tracks(track_ios, &block)
      file_allocation_info = read_record(Records::FileAllocationInfo, sector: @file_allocation_info_sector, count: 5)
      block_ranges = file_allocation_info.file_allocation_block_ranges
      num_blocks = block_ranges.map(&:count).sum
      sub_block_size = @project.drive.audio_block_size / @num_actual_tracks
      blocks_read = 0
      block_ranges.each do |block_range|
        fs.seek_sector(block_range.begin)
        block_range.count.times do |block_num|
          track_ios.each do |track_io|
            data = fs.read_sectors(sub_block_size)
            track_io.write(data) if track_io
          end
          yield(Progress.new(song: self, phase: :extracting, total: num_blocks, advance: 1)) if block_given?
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

    def convert_pcm_files(pcm_files, dir:, extension:, &block)
      @num_tracks.times.map do |track|
        converted_file = path_for_track(track, dir:, extension:)
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
        command = TTY::Command.new(printer: :null)
        command.run(*cmd.flatten.compact.map(&:to_s))
        yield(Progress.new(song: self, phase: :converting, total: @num_tracks, advance: 1)) if block_given?
        converted_file
      end
    end

    private

    def read(sector)
      song_info = read_record(Records::SongInfo, sector:, count: 2)
      @name = song_info.song_name
      @sample_rate = song_info.sample_rate
      @sample_depth = song_info.sample_depth
      secs = song_info.num_samples.to_f / @sample_rate
      secs *= 2 if high_resolution?
      @duration = Duration.from_seconds(secs)
      @num_actual_tracks = song_info.num_tracks
      @num_tracks = high_resolution? ? (@num_actual_tracks / 2) : @num_actual_tracks
      @file_allocation_info_sector = sector + 2
    end

  end

end