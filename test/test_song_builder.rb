require 'midi-mmc'
require 'set_params'
require 'tone-gen'
require 'unimidi'

require_relative '../lib/hd24dig'

class TestSong

  attr_accessor :midi_output_device_name
  attr_accessor :tmp_dir
  attr_accessor :output_type
  attr_accessor :output_name
  attr_accessor :num_tracks
  attr_accessor :channels
  attr_accessor :duration
  attr_accessor :rate

  include SetParams

  def initialize(**params)
    super
    @midi_output = UniMIDI::Output.find { |d| d.name == @midi_output_device_name } \
      or raise "Can't find MIDI output device named #{@midi_output_device_name.inspect}"
    @tmp_dir.rmtree if @tmp_dir.exist?
    @tmp_dir.mkpath
  end

  def build
    @tone_files = {}
    0.step(to: @num_tracks - 1, by: @channels) do |track|
      tone_gen = ToneGen.new(rate:)
      channel_files = @channels.times.map do |channel|
        tone_gen.make_pitch_file(
          pitch: tone_gen.make_pitch(index: track + channel),
          duration:,
          file: (@tmp_dir / ('t%02dc%02d' % [track, channel])).add_extension('.wav'),
        )
      end
      track_range = track .. (track + @channels - 1)
      merged_file = (@tmp_dir / ('t%02d-%02d' % [track_range.begin, track_range.end])).add_extension('.wav')
      HD24Dig.run_command(
        'sox',
        '--combine', 'merge',
        channel_files,
        merged_file,
        'gain', -6,
      )
      @tone_files[track_range] = merged_file
    end
    @tone_files
  end

  def record
    build unless @tone_files
    mmc = MIDI::MMC.new(output: @midi_output, debug: true)
    mmc.reset
    @tone_files.each do |track_range, file|
      puts "%5s: %s" % [track_range, file]
      begin
        mmc.write(track_range.to_a)
        mmc.goto_zero
        mmc.record_strobe
        HD24Dig.run_command(
          'sox',
          file,
          @output_type && ['--type', @output_type],
          @output_name,
        )
      ensure
        mmc.stop
      end
    end
    mmc.goto_zero
    mmc.write(nil)
    mmc.reset
  end

end