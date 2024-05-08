require_relative 'helpers'

module HD24Extractor::Tests

  class ExtractTest < Minitest::Test

    DRIVE_IMAGE_FILE = Path.new('~/Projects/audio:video/studio/work/hd24-images/test.hd24').expand_path

    include HD24Extractor::TestUtils

    def setup
      TMP_DIR.rmtree if TMP_DIR.exist?
      TMP_DIR.mkpath
      @drive = HD24Extractor.open_drive(DRIVE_IMAGE_FILE)
      @project = @drive.projects.first
    end

    EXPECTED_SONGS = [
      {
        name: 'Song Name',
        duration: [0, 0, 7, 0],
        num_tracks: 8,
        sample_rate: 48000,
      },
      {
        name: 'Song Name',
        duration: [0, 0, 7, 0],
        num_tracks: 8,
        sample_rate: 48000,
      },
    ]

    def test_extract
      drive_name = @drive.name
      assert { drive_name == 'Drive Name' }
      assert { @project != nil }
      project_name = @project.name
      assert { project_name == 'Proj Name' }
      num_songs = @project.songs.count
      expected_num_songs = EXPECTED_SONGS.count
      assert { num_songs == expected_num_songs }
      @project.songs.each_with_index do |song, i|
        expected = EXPECTED_SONGS[i]
        name, duration, sample_rate = song.name, song.duration, song.sample_rate
        assert { name == expected[:name] }
        expected_duration = HD24Extractor::Duration.from_array(expected[:duration])
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