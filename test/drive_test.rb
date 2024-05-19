require 'tone-gen'

require_relative 'helpers'

module HD24::Tests

  class DriveTest < Minitest::Test

    include HD24::TestHelpers

    def setup
      @expected_drive = eval(TEST_SETUP_FILE.read)
      @drive = HD24.open_drive(DRIVE_IMAGE_FILE)
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
          tone_gen = ToneGen.new
          files.each_with_index do |file, i|
            expected_pitch = tone_gen.make_pitch(index: i)
            pitch = tone_gen.pitch_for_file(file)
            assert { pitch == expected_pitch }
          end
        end
      end
    end

  end

end