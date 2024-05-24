$VERBOSE = false

require 'minitest/autorun'
require 'minitest/power_assert'

require_relative '../lib/hd24dig'

module HD24Dig

  module TestHelpers

    TMP_DIR = Path.new('test/tmp')
    DRIVE_IMAGE_FILE = Path.new('test/test.hd24').expand_path
    TEST_SETUP_FILE = Path.new('test/test_setup.rb')

  end

end