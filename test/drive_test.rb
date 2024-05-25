require 'tone-gen'

require_relative 'helpers'

module HD24Dig::Tests

  class DriveTest < Minitest::Test

    include HD24Dig::TestHelpers

    def setup
      @expected_drive = eval(TEST_SETUP_FILE.read)
      @drive = HD24Dig.open_drive(DRIVE_IMAGE_FILE)
    end

    def test_load
      assert { @drive == @expected_drive }
    end

    def test_extract
      TMP_DIR.rmtree if TMP_DIR.exist?
      TMP_DIR.mkpath
      @drive.projects.each do |project|
        project.songs.each do |song|
          files = song.extract_audio(dir: TMP_DIR)
          assert { files.length == song.num_tracks }
          expected_duration = song.duration
          tone_gen = ToneGen.new
          files.each_with_index do |file, i|
            duration = HD24Dig::Duration.from_file(file)
            assert { duration == expected_duration }
            pitch = tone_gen.pitch_for_file(file)
            expected_pitch = tone_gen.make_pitch(index: i)
            assert { pitch == expected_pitch }
          end
        end
      end
    end

  end

end