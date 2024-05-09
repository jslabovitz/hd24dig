$VERBOSE = false

require 'minitest/autorun'
require 'minitest/power_assert'

require_relative '../lib/hd24'
require_relative '../lib/hd24/test_utils'

module HD24

  module TestHelpers

    TMP_DIR = Path.new('test/tmp')

    include HD24::TestUtils

  end

end