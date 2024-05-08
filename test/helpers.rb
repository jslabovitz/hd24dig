$VERBOSE = false

require 'minitest/autorun'
require 'minitest/power_assert'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'hd24'
require 'hd24/test_utils'

module HD24

  module Tests

    TMP_DIR = Path.new('test/tmp')

  end

end