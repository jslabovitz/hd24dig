require 'tone-gen'

require_relative 'helpers'

module HD24Dig::Tests

  class DriveTest < Minitest::Test

    include HD24Dig::TestHelpers

    def setup
      TMP_DIR.rmtree if TMP_DIR.exist?
      TMP_DIR.mkpath
      @expected_drive = HD24Dig.load_drive(TEST_SETUP_FILE)
      @drive = HD24Dig.open_drive(DRIVE_IMAGE_FILE)
    end

    def test_load
      assert { @drive == @expected_drive }
    end

    def test_extract
      @drive.projects.each do |project|
        project.songs.each do |song|
          files = song.extract_audio(dir: TMP_DIR)
          assert { files.length == song.num_tracks }
          expected_duration = song.duration
          tone_gen = ToneGen.new
          files.each_with_index do |file, i|
            duration = HD24Dig::Duration.new(file)
            assert { duration == expected_duration }
            pitch = tone_gen.pitch_for_file(file)
            expected_pitch = tone_gen.make_pitch(index: i)
            assert { pitch == expected_pitch }
          end
        end
      end
    end

    def test_clone
      clone_file = TMP_DIR / 'clone.hd24'
      drive = HD24Dig.open_drive(DRIVE_IMAGE_FILE, clone: clone_file)
      drive.clone
      assert { clone_file.exist? }
    end

  end

end