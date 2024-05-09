# NOTE: This file is not included by default, as it mostly contains methods only used when testing.
#
# If you need it, simple add:
#
#   require 'hd24/test_utils'

require 'midi-mmc'
require 'tty-command'
require 'unimidi'

module HD24

  module TestUtils

    def make_tone(note:, duration:, rate:, type:, gain: -6, output: nil, num_channels: nil, channel: nil)
      run_command(
        'sox',
        '--null',
        '--rate', rate,
        '--channels', 1,
        output,
        'synth', duration, type, midi_note_num_to_name(note),
        (gain ? ['gain', gain] : nil),
        (channel ? ['remix', *make_channel_map(channel:, num_channels:)] : nil),
      )
    end

    def make_channel_map(channel:, num_channels:)
      num_channels.times.map do |i|
        (channel == i) ? 1 : 0
      end
    end

    def note_num_for_track(track, base: 'C3', interval: 1)
      midi_note_name_to_num(base) + (track * interval)
    end

    def find_note(file:)
      out, err = run_command(
        'aubionotes',
        '--input', file,
        '--pitch-unit', 'midi',
      )
      warn "aubio errors: #{err}" unless err.empty?
      values = out.split(/\n/).map do |line|
        fields = line.split(/\s+/)
        if fields.length == 3
          fields.first.to_i
        else
          nil
        end
      end.compact.uniq
      raise "Couldn't detect notes" if values.empty?
      raise "Detected multiple notes: #{values.inspect}" if values.length > 1
      values.first
    end

    NOTE_NAMES = %w[C C# D D# E F F# G G# A A# B]

    def midi_note_num_to_name(num)
      '%s%d' % [
        NOTE_NAMES[num % NOTE_NAMES.count],
        (num / NOTE_NAMES.count) - 1,
      ]
    end

    def midi_note_name_to_num(name)
      note, octave = name.match(/^(.*?)(\d+)$/).captures
      octave = octave.to_i + 1
      note_index = NOTE_NAMES.index(note)
      (octave * NOTE_NAMES.count) + note_index
    end

    def record_test_song(
      midi_output_device_id:,
      num_tracks:,
      tone_duration:,
      track_rate:,
      audio_device: ['coreaudio', 'Digiface USB (23801173)'])

      mmc = MIDI::MMC.new(output: open_midi_device(id: midi_output_device_id))

      puts; puts "[setting up]"
      mmc.reset

      begin
        num_tracks.times do |track|
          note = note_num_for_track(track)
          puts; puts "[track %2d, note %3d (%2s)]" % [
            track,
            note,
            midi_note_num_to_name(note),
          ]
          mmc.goto_zero
          mmc.write(track)
          mmc.record_strobe
          make_tone(
            type: 'pluck',
            note: note,
            rate: track_rate,
            duration: tone_duration,
            output: ['--type', audio_device],
            num_channels: num_tracks,
            channel: track)
          mmc.stop
        end
      ensure
        puts; puts "[shutting down]"
        mmc.stop
        mmc.goto_zero
        mmc.write(nil)
        mmc.reset
      end
    end

    def open_midi_device(id:)
      UniMIDI::Output.all.find { |o| o.id == id } or raise "Can't find MIDI output device #{id}"
    end

    def run_command(*args)
      @command ||= TTY::Command.new(
        printer: :null
      )
      @command.run(*args.flatten.compact.map(&:to_s))
    end

    DUMP_PRINTABLE_BYTES = 32..127

    def dump_data(data, prefix: nil, output: STDOUT)
      0.step(by: 4, to: data.length - 1) do |offset|
        chunk = data[offset, 4]
        words = chunk.unpack('L*')
        bytes = chunk.bytes
        output.puts '%s+ 0x%04x         %s      %s      %s      %s      %s' % [
          prefix,
          offset,
          words.map { |w| '0x%08x' % w }.join(', '),
          words.map { |w| '%10d' % w }.join(', '),
          bytes.map { |b| '0x%02x' % b }.join(', '),
          bytes.map { |b| '%3d' % b }.join(', '),
          bytes.map { |b| DUMP_PRINTABLE_BYTES.include?(b) ? b.chr : '.' }.join,
        ]
      end
      output.puts
    end

  end

end