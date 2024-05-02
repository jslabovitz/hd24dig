$VERBOSE = false

require 'minitest/autorun'
require 'minitest/power_assert'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'hd24'

class HD24::DurationTest < Minitest::Test

  def test_params
    duration = HD24::Duration.new(minutes: 5)
    assert { duration.minutes == 5 }
    assert { duration.to_seconds == 300 }
  end

  def test_array
    duration = HD24::Duration.from_array([0, 0, 1, 15])
    secs = duration.to_seconds
    assert { secs == 1.5 }
  end

  def test_seconds
    duration = HD24::Duration.from_seconds(1.5)
    assert { duration.to_array == [0, 0, 1, 15] }
  end

end