require 'pitch'

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

    def test_extract
      ftp_files = FTP_DIR.glob('**/*.wav').map { |p| [p.relative_to(FTP_DIR / 'Drive1'), p] }.to_h
      @drive.projects.each_with_index do |project, project_idx|
        expected_project = @expected_drive.projects[project_idx]
        assert { project == expected_project }
        project.songs.each_with_index do |song, song_idx|
          expected_song = expected_project.songs[song_idx]
          assert { song == expected_song }
          files = song.extract_audio(dir: EXTRACT_DIR)
          assert { files.count == song.num_tracks }
          expected_num_samples = song.num_samples
          files.each_with_index do |file, i|
            # samples
            num_samples = num_samples_in_file(file)
            assert { num_samples == expected_num_samples }
            # pitch
            pitch = Pitch.read_from_file(file)
            expected_pitch = PITCH_BASE + (i * PITCH_INTERVAL)
            assert { pitch == expected_pitch }
            # data
            ftp_file = ftp_files.delete(file.relative_to(EXTRACT_DIR / @drive.full_name))
            assert { ftp_file != nil }
            assert { pcm_files_equivalent?(ftp_file, file) }
          end
        end
      end
      assert { ftp_files.empty? }
    end

    def test_copy
      copy_file = TMP_DIR / 'copy.hd24'
      drive = HD24Dig.open_drive(DRIVE_IMAGE_FILE, copy_file:)
      drive.copy
      assert { copy_file.exist? }
    end

  end

end