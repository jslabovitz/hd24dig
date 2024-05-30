require 'midi-mmc'
require 'path'
require 'unimidi'

require_relative '../test/test_constants'
require_relative '../test/test_song_builder'

desc 'Build test harness'
task :build_test_harness do

  include HD24Dig::TestConstants

  midi_output = UniMIDI::Output.find { |d| d.name == MIDI_OUTPUT_DEVICE_NAME }
  warn "Can't find MIDI output device named #{MIDI_OUTPUT_DEVICE_NAME.inspect}" unless midi_output
  mmc = MIDI::MMC.new(output: midi_output, debug: true)

  HARNESS_DIR.rmtree if HARNESS_DIR.exist?
  HARNESS_DIR.mkpath

  drive = HD24Dig.load_drive(TEST_SETUP_FILE)
  drive.projects.each do |project|
    project.songs.each do |song|
      puts
      puts "On HD24, create new song with rate = #{song.sample_rate} kHz, tracks = #{song.num_tracks}"
      print "Create? "
      next if STDIN.gets.chomp != 'y'
      song_dir = HARNESS_DIR / song.full_name
      song_dir.rmtree if song_dir.exist?
      song_dir.mkpath
      builder = TestSongBuilder.new(
        dir: song_dir,
        num_tracks: song.num_tracks,
        duration: song.duration.to_seconds,
        rate: song.sample_rate,
        pitch_base: PITCH_BASE,
        pitch_interval: PITCH_INTERVAL,
        num_output_channels: NUM_OUTPUT_CHANNELS,
        mmc: mmc,
        output_name: OUTPUT_NAME,
        output_type: OUTPUT_TYPE,
      )
      builder.build
      builder.record
    end
  end

end