require_relative 'helpers'

module HD24::Tests

  class DriveTest < Minitest::Test

    DRIVE_IMAGE_FILE = Path.new('~/Projects/audio:video/studio/work/hd24-images/test.hd24').expand_path
    # DRIVE_IMAGE_FILE = Path.new('/dev/disk4').expand_path
    TEST_SETUP_FILE = Path.new('test/test_setup.rb')

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
      @drive.extract_audio(dir: TMP_DIR)
      @drive.projects.each do |project|
        project.songs.each do |song|
          song.num_tracks.times do |track|
            expected_note = note_num_for_track(track)
            note = find_note(file: song.path_for_track(track, dir: TMP_DIR))
            assert { note == expected_note }
          end
        end
      end
    end

  end

end