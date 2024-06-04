require 'midi-mmc'
require 'path'
require 'pitch'
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
    @tracks = 1.step(to: num_tracks, by: @num_output_channels).map do |track_start|
      track_range = track_start .. (track_start + @num_output_channels - 1)
      pitch_files = track_range.map do |track|
        track_name = 'Track %02d' % track
        pitch_file = (@dir / track_name).add_extension('.wav')
        pitch.write_to_file(pitch_file, duration: @duration, rate: @rate)
        pitch += @pitch_interval
        pitch_file
      end
      track_file = (dir / ('Tracks %02d-%02d' % [track_range.begin, track_range.end])).add_extension('.wav')
      HD24Dig.run_command(
        'sox',
        '--combine', 'merge',
        pitch_files,
        track_file,
        'gain', -6,
      )
      pitch_files.each(&:unlink)
      [track_range, track_file]
    end.to_h
  end

  def record
    @mmc.reset
    @tracks.each do |track_range, track_file|
      puts '%s: %s' % [track_range, track_file]
      begin
        @mmc.arm_tracks(track_range.to_a)
        @mmc.goto_zero
        @mmc.record_strobe
        HD24Dig.run_command(
          'sox',
          track_file,
          @output_type && ['--type', @output_type],
          @output_name,
        )
      ensure
        @mmc.stop
      end
    end
    @mmc.goto_zero
    @mmc.arm_tracks(nil)
    @mmc.reset
  end

end