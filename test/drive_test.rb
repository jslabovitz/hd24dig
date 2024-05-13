require_relative 'helpers'

module HD24::Tests

  class ExtractTest < Minitest::Test

    # DRIVE_IMAGE_FILE = Path.new('~/Projects/audio:video/studio/work/hd24-images/test.hd24').expand_path
    DRIVE_IMAGE_FILE = Path.new('/dev/disk4').expand_path

    include HD24::TestHelpers

    EXPECTED_SONGS = [
      {
        name: 'Song Name',
        duration: [0, 0, 2, 0],
        num_tracks: 8,
        sample_rate: 48000,
      },
    ]

    def test_extract
      TMP_DIR.rmtree if TMP_DIR.exist?
      TMP_DIR.mkpath
      drive = HD24.open_drive(DRIVE_IMAGE_FILE)
      drive_name = drive.name
      assert { drive_name == 'Drive Name' }
      project = drive.projects.first
      assert { project.drive == drive }
      project_name = project.name
      assert { project_name == 'Proj Name' }
      songs = project.songs
      num_songs = songs.count
      expected_num_songs = EXPECTED_SONGS.count
      assert { num_songs == expected_num_songs }
      songs.each_with_index do |song, i|
        assert { song.project == project }
        expected = EXPECTED_SONGS[i]
        name, duration, sample_rate = song.name, song.duration, song.sample_rate
        assert { name == expected[:name] }
        expected_duration = HD24::Duration.from_array(expected[:duration])
        assert { duration.to_seconds.to_i == expected_duration.to_seconds.to_i }
        assert { sample_rate == expected[:sample_rate] }
        dir = TMP_DIR / song.num.to_s
        dir.mkpath
        track_paths = song.extract_audio(dir)
        assert { track_paths.length == expected[:num_tracks] }
        track_paths.each_with_index do |path, track|
          expected_note = note_num_for_track(track)
          note = find_note(file: path)
          assert { note == expected_note }
        end
      end
    end

  end

end