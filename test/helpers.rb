$VERBOSE = false

require 'minitest/autorun'
require 'minitest/power_assert'

require_relative '../lib/hd24'

module HD24

  module TestHelpers

    TMP_DIR = Path.new('test/tmp')
    DRIVE_IMAGE_FILE = Path.new('~/Projects/audio:video/studio/work/hd24-images/test.hd24').expand_path
    # DRIVE_IMAGE_FILE = Path.new('/dev/disk4').expand_path
    TEST_SETUP_FILE = Path.new('test/test_setup.rb')

  end

end