module HD24Dig

  module Parts

    class Track < Part

      ATTRS = %i[
        channels
        dir
        pcm_file
        io
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
        channel = Channel.new(**channel) if channel.kind_of?(Hash)
        channel.num = @channels.length + 1
        channel.track = self
        @channels << channel
      end

      def channel_sample_rate
        @channel_sample_rate ||= (@song.sample_rate / @channels.count)
      end

      def extract_audio(extension:)
        out_file = @pcm_file.replace_extension(extension)
        cmd = [
          'sox',
          '--type', 'raw',
          '--rate', @song.sample_rate,
          '--bits', BITS_PER_SAMPLE,
          '--encoding', 'signed-integer',
          '--channels', 1,
          @pcm_file,
          out_file,
        ]
        HD24Dig.run_command(cmd)
        out_file
      end

      def demux_channels
        @pcm_file.open('wb') do |output|
          @channels.each { |c| c.io = c.pcm_file.open('rb') }
          inputs = @channels.map(&:io)
          until inputs.first.eof do
            inputs.each do |input|
              data = input.read(BYTES_PER_SAMPLE) or break
              output.write(data)
            end
          end
        end
      end

    end

  end

end