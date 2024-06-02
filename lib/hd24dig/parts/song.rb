module HD24Dig

  module Parts

    class Song < Part

      ATTRS = %i[
        sample_rate
        sample_depth
        num_tracks
        num_channel
        num_samples
        timecode
        tracks
      ]
      attr_accessor *ATTRS
      attr_accessor :project

      def initialize(**)
        @tracks = []
        super
        make_tracks if @num_tracks
      end

      def comparable_attributes
        super + ATTRS - [:num_samples]
      end

      def inspectable_attributes
        super + ATTRS
      end

      def make_tracks
        @num_tracks.times do
          add_track(
            Track.new(channels: num_channels.times.map { Channel.new })
          )
        end
      end

      def tracks=(tracks)
        @tracks = []
        tracks.each { |t| add_track(t) }
      end

      def add_track(track)
        track = Track.new(**track) if track.kind_of?(Hash)
        track.num = @tracks.length + 1
        track.song = self
        @tracks << track
      end

      def timecode=(timecode)
        @timecode = Timecode.new(timecode, TIMECODE_FPS)
      end

      def resolution
        '%d/%d' % [@sample_depth, @sample_rate / 1000]
      end

      def num_channels
        @num_channels ||= case @sample_rate
        when 44100, 48000
          1
        when 88200, 96000
          2
        else
          raise
        end
      end

      def extract_audio(dir: nil)
        song_dir = dir&.join(@project.drive.full_name, @project.full_name, full_name)
        channel_ios = @tracks.map(&:channels).flatten.map do |channel|
          if dir
            path = (song_dir / channel.track.full_name / channel.full_name).add_extension('.pcm')
            path.dirname.mkpath
            io = path.open('wb')
          else
            io = nil
          end
          [channel, io]
        end.to_h
        samples_to_read = @num_samples_per_channel
        @block_ranges.each do |block_range|
          @fs.seek_sector(block_range.begin)
          block_range.count.times do
            sub_block_samples = [samples_to_read, @num_samples_per_sub_block].min
            sub_block_bytes = sub_block_samples * 3  #FIXME: don't use constant
            channel_ios.values.each do |io|
              data = @fs.read_sectors(@num_sectors_per_sub_block) or raise "Unexpected EOF"
              io&.write(data[0, sub_block_bytes])
            end
            samples_to_read -= sub_block_samples
          end
        end
        channel_ios.values.compact.each(&:close)
        if dir
          @tracks.map do |track|
            channel_files = track.channels.map { |c| Path.new(channel_ios[c].path) }
            track_dir = song_dir / track.full_name
            wav_file = track_dir.add_extension('.wav')
            track.demux_channels(channel_files, wav_file)
            track_dir.rmtree
            wav_file
          end
        end
      end

      private

      def read(sector)
        song_info = read_record(Records::SongInfo, sector:, count: 2)
        @name = song_info.song_name
        @sample_rate = song_info.sample_rate
        @sample_depth = song_info.sample_depth
        @num_samples_per_channel = song_info.num_samples
        @num_samples = @num_samples_per_channel * num_channels
        @num_tracks = song_info.num_tracks / num_channels
        frames = ((@num_samples.to_f / @sample_rate) * TIMECODE_FPS).round
        @timecode = Timecode.new(frames, TIMECODE_FPS)
        make_tracks
        file_allocation_info = read_record(Records::FileAllocationInfo, sector: sector + 2, count: 5)
        @block_ranges = file_allocation_info.file_allocation_block_ranges
        @num_sectors_per_sub_block = song_info.num_sectors_per_sub_block
        @num_samples_per_sub_block = song_info.num_samples_per_sub_block
      end

    end

  end

end