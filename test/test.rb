$VERBOSE = false

require 'minitest/autorun'
require 'minitest/power_assert'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'hd24'

class HD24::Test < Minitest::Test

  TEST_IMAGE_PATH = '~/Projects/audio:video/studio/work/hd24-images/main-backup-1.img'

  def test_open
    drive = HD24.open(File.expand_path(TEST_IMAGE_PATH))
    assert { drive.name == 'Drive Name' }
  end

end