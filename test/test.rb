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
    song = project.songs.first
    assert { song != nil }
    song_name = song.name
    assert { song_name == 'Song Name' }
    # audio
    audio_path = File.join(TMP_PATH, 'audio.pcm')
    File.open(audio_path, 'w') do |io|
      song.extract_audio(io)
    end
    #FIXME
    # assert { File.size(audio_path) == 12345 }
  end

end