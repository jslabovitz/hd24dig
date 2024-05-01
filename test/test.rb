$VERBOSE = false

require 'minitest/autorun'
require 'minitest/power_assert'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'hd24'

class HD24::Test < Minitest::Test

  IMAGE_PATH = '~/Projects/audio:video/studio/work/hd24-images/main-backup-1.img'
  TMP_PATH = 'test/tmp'

  def setup
    FileUtils.rm_rf(TMP_PATH) if File.exist?(TMP_PATH)
    Dir.mkdir(TMP_PATH)
  end

  def test_open
    # drive
    drive = HD24.open(File.expand_path(IMAGE_PATH))
    drive_name = drive.name
    assert { drive_name == 'Drive Name' }
    # project
    project = drive.projects.first
    assert { project != nil }
    project_name = project.name
    assert { project_name == 'Proj Name' }
    # song
    song = project.songs.find { |s| s.num == 2 }
    assert { song != nil }
    song_name = song.name
    assert { song_name == 'Drum Bed' }
    # audio
    track_paths = song.extract_audio(TMP_PATH)
    assert { track_paths.length == 8 }
    track_paths.each do |path|
      assert { File.size(path) == 16293968 }
    end
  end

end