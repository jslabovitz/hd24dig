module HD24Dig

  class Track < Part

    ATTRS = %i[
      channels
    ]
    attr_accessor *ATTRS
    attr_accessor :song

    def initialize(**)
      @channels = []
      super
    end

    def comparable_attributes
      super + ATTRS
    end

    def inspectable_attributes
      super + ATTRS
    end

    def channels=(channels)
      @channels = []
      channels.each { |c| add_channel(c) }
    end

    def add_channel(channel)
      channel.num = @channels.length + 1
      channel.track = self
      @channels << channel
    end

    def full_name
      '%s %02d' % [@name, num]
    end

    def channel_sample_rate
      @channel_sample_rate ||= (@song.sample_rate / @channels.count)
    end

    def demux_channels(input_files, output_file)
      cmd = ['ffmpeg']
      input_files.each do |input_file|
        cmd += [
          '-f', 's24le',
          '-ar', channel_sample_rate,
          '-ac', 1,
          '-i', input_file,
        ]
      end
      if input_files.count > 1
        cmd += [
          '-filter_complex', make_filter_complex,
        ]
      end
      cmd += [
        '-acodec', 'pcm_s24le',
        output_file,
      ]
      HD24Dig.run_command(cmd)
    end

    def make_filter_complex
      channel_ids = @channels.map { |c| c.num - 1 }
      [
        channel_ids.map { |id| "[#{id}:a]" }.join,
        "amerge=inputs=#{@channels.count},",
        "aresample=#{@song.sample_rate},",
        "pan=mono|c0=#{channel_ids.map { |id| "c#{id}" }.join('+')}",
      ].join
    end

  end

end