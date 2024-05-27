require 'path'
require_relative '../test/test_song_builder'

desc 'Build test harness'
task :build_test_harness do
  TMP_DIR = Path.new('test/tmp/test-harness')
  MIDI_OUTPUT_DEVICE_NAME = 'ZOOM Corporation U-44'
  OUTPUT_TYPE = 'coreaudio'
  OUTPUT_NAME = 'ZOOM U-44 Driver'
  OUTPUT_CHANNELS = 2
  TEST_SETUP_FILE = Path.new('test/test_setup.rb')

  @drive = HD24Dig.load_drive(TEST_SETUP_FILE)

  @drive.projects.each do |project|
    project.songs.each do |song|
      puts
      puts "On HD24, create new song with rate = #{song.sample_rate} kHz, tracks = #{song.num_tracks}"
      print "Create? "
      next if STDIN.gets.chomp != 'y'
      test_song = TestSong.new(
        num_tracks: song.num_tracks,
        duration: song.duration.to_seconds,
        rate: song.sample_rate,
        channels: OUTPUT_CHANNELS,
        midi_output_device_name: MIDI_OUTPUT_DEVICE_NAME,
        tmp_dir: TMP_DIR,
        output_type: OUTPUT_TYPE,
        output_name: OUTPUT_NAME,
      )
      test_song.build
      test_song.record
    end
  end
end