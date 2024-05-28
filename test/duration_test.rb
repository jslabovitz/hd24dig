require_relative 'helpers'

module HD24Dig::Tests

  class DurationTest < Minitest::Test

    include HD24Dig::TestHelpers

    def test_seconds
      duration = HD24Dig::Duration.new(1.5)
      assert { duration.to_a == [0, 0, 1, 15] }
    end

    def test_string
      duration = HD24Dig::Duration.new('00:00:07:12')
      assert { duration.to_a == [0, 0, 7, 12] }
      assert { duration.to_seconds.to_i == 7 }
    end

    def test_hash
      duration = HD24Dig::Duration.new(minutes: 5)
      assert { duration.minutes == 5 }
      assert { duration.to_seconds == 300 }
    end

    def test_array
      duration = HD24Dig::Duration.new([0, 0, 1, 15])
      secs = duration.to_seconds
      assert { secs == 1.5 }
    end

    def test_file
      duration = HD24Dig::Duration.new(Path.new('test/tone.flac'))
      secs = duration.to_seconds
      assert { secs == 5 }
    end

    def test_eq
      d1 = HD24Dig::Duration.new(5)
      d2 = HD24Dig::Duration.new('00:00:05:00')
      assert { d1 == d2 }
    end

  end

end