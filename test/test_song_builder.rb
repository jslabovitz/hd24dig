require 'set_params'

require_relative '../lib/hd24dig'
require_relative 'test_constants'

class TestSongBuilder

  attr_accessor :dir
  attr_accessor :num_tracks
  attr_accessor :duration
  attr_accessor :rate
  attr_accessor :pitch_base
  attr_accessor :pitch_interval
  attr_accessor :num_output_channels
  attr_accessor :mmc
  attr_accessor :output_name
  attr_accessor :output_type

  include SetParams

  def build
    pitch = @pitch_base.dup
    @track_files = 0.step(by: @num_output_channels, to: num_tracks - 1).map do |track_start|
      track_range = track_start .. (track_start + @num_output_channels - 1)
      pitch_files = track_range.map do |track|
        track_name = 'Track %02d' % (track + 1)
        pitch_file = (@dir / track_name).add_extension('.wav')
        pitch.write_to_file(pitch_file, duration: @duration, rate: @rate)
        pitch += @pitch_interval
        pitch_file
      end
      output_file = (dir / ('Tracks %02d-%02d' % [track_range.begin, track_range.end])).add_extension('.wav')
      HD24Dig.run_command(
        'sox',
        '--combine', 'merge',
        pitch_files,
        output_file,
        'gain', -6,
      )
      pitch_files.each(&:unlink)
      [track_range, output_file]
    end.to_h
  end

  def record
    @mmc.reset
    @track_files.each do |range, file|
      puts '%s: %s' % [range, file]
      begin
        @mmc.write(range.to_a)
        @mmc.goto_zero
        @mmc.record_strobe
        HD24Dig.run_command(
          'sox',
          file,
          @output_type && ['--type', @output_type],
          @output_name,
        )
      ensure
        @mmc.stop
      end
    end
    @mmc.goto_zero
    @mmc.write(nil)
    @mmc.reset
  end

end