module HD24Extractor

  class Duration

    attr_accessor :hours
    attr_accessor :minutes
    attr_accessor :seconds
    attr_accessor :frames

    include SetParams

    def self.from_seconds(seconds)
      int_seconds = seconds.to_i
      frames = ((seconds - int_seconds) * 30).round
      hours, int_seconds = int_seconds.divmod(3600)
      minutes, seconds = int_seconds.divmod(60)
      new(hours:, minutes:, seconds:, frames:)
    end

    def self.from_array(array)
      new(
        hours: array[0] || 0,
        minutes: array[1] || 0,
        seconds: array[2] || 0,
        frames: array[3] || 0)
    end

    def initialize(**)
      @hours = @minutes = @seconds = @frames = 0
      super
    end

    def to_s
      '%02d:%02d:%02d:%02d' % [
        @hours,
        @minutes,
        @seconds,
        @frames,
      ]
    end

    def to_seconds
      (@hours * 3600) + (@minutes * 60) + @seconds + (@frames / 30.0)
    end

    def to_array
      [@hours, @minutes, @seconds, @frames]
    end

  end

end