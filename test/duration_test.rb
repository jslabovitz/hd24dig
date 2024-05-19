require_relative 'helpers'

module HD24Dig::Tests

  class DurationTest < Minitest::Test

    include HD24Dig::TestHelpers

    def test_params
      duration = HD24Dig::Duration.new(minutes: 5)
      assert { duration.minutes == 5 }
      assert { duration.to_seconds == 300 }
    end

    def test_array
      duration = HD24Dig::Duration.from_array([0, 0, 1, 15])
      secs = duration.to_seconds
      assert { secs == 1.5 }
    end

    def test_string
      duration = HD24Dig::Duration.from_string('00:00:07:12')
      assert { duration.to_array == [0, 0, 7, 12] }
      assert { duration.to_seconds.to_i == 7 }
    end

    def test_seconds
      duration = HD24Dig::Duration.from_seconds(1.5)
      assert { duration.to_array == [0, 0, 1, 15] }
    end

  end

end