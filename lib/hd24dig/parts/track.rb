module HD24Dig

  module Parts

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
        channel = Channel.new(**channel) if channel.kind_of?(Hash)
        channel.num = @channels.length + 1
        channel.track = self
        @channels << channel
      end

      def channel_sample_rate
        @channel_sample_rate ||= (@song.sample_rate / @channels.count)
      end

      def demux_channels(input_files, output_file)
        intermediate_file = nil
        if input_files.length > 1
          intermediate_file = output_file.replace_extension('.pcm')
          intermediate_file.open('wb') do |output|
            inputs = input_files.map { |f| f.open('rb') }
            until inputs.first.eof do
              inputs.each do |input|
                data = input.read(BYTES_PER_SAMPLE) or break
                output.write(data)
              end
            end
          end
        end
        cmd = [
          'sox',
          '--type', 'raw',
          '--rate', @song.sample_rate,
          '--bits', BITS_PER_SAMPLE,
          '--encoding', 'signed-integer',
          '--channels', 1,
          intermediate_file || input_files.first,
          output_file,
        ]
        HD24Dig.run_command(cmd)
        intermediate_file&.unlink
      end

    end

  end

end