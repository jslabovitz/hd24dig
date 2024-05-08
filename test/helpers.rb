$VERBOSE = false

require 'minitest/autorun'
require 'minitest/power_assert'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'hd24-extractor'
require 'hd24-extractor/test_utils'

module HD24Extractor

  module Tests

    TMP_DIR = Path.new('test/tmp')

  end

end