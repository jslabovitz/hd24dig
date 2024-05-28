module HD24Dig

  class Duration

    attr_accessor :hours
    attr_accessor :minutes
    attr_accessor :seconds
    attr_accessor :frames

    include SetParams

    def initialize(obj)
      @hours = @minutes = @seconds = @frames = 0
      case obj
      when nil
        # nothing
      when Duration
        set(obj.to_h)
      when Numeric
        set_from_seconds(obj)
      when Array
        set_from_array(obj)
      when String
        set_from_string(obj)
      when Path
        set_from_file(obj)
      when Hash
        set(obj)
      else
        raise ArgumentError, "Unknown duration specification: #{obj.inspect}"
      end
    end

    def set_from_seconds(seconds)
      int_seconds = seconds.to_i
      frames = ((seconds - int_seconds) * 30).round
      hours, int_seconds = int_seconds.divmod(3600)
      minutes, seconds = int_seconds.divmod(60)
      set(hours:, minutes:, seconds:, frames:)
    end

    def set_from_array(array)
      raise ArgumentError if array.length > 4
      set(
        hours:   array[0] || 0,
        minutes: array[1] || 0,
        seconds: array[2] || 0,
        frames:  array[3] || 0)
    end

    def set_from_string(string)
      set_from_array(string.split(':').map(&:to_i))
    end

    def set_from_file(file)
      out, _ = HD24Dig.run_command('soxi', '-D', file)
      set_from_seconds(out.to_f)
    end

    def ==(other)
      to_a == other&.to_a
    end

    def +(other)
      self.class.new(to_seconds + other.to_seconds)
    end

    def -(other)
      self.class.new(to_seconds - other.to_seconds)
    end

    def *(other)
      self.class.new(to_seconds * other.to_seconds)
    end

    def /(other)
      self.class.new(to_seconds / other.to_seconds)
    end

    def to_s
      '%02d:%02d:%02d:%02d' % to_a
    end

    def to_seconds
      (@hours * 3600) + (@minutes * 60) + @seconds + (@frames / 30.0)
    end

    def to_f
      to_seconds
    end

    def to_i
      to_seconds.to_i
    end

    def to_a
      [@hours, @minutes, @seconds, @frames]
    end

    def to_h
      { hours:, minutes:, seconds:, frames: }
    end

  end

end