require_relative 'helpers'

module HD24::Tests

  class NotesTest < Minitest::Test

    include HD24::TestUtils

    def test_notes
      file = TMP_DIR / 'note.wav'
      24.times do |track|
        note = note_num_for_track(track)
        # ;;pp(track:, note:)
        make_tone(
          note:,
          duration: 2,
          output: file,
          rate: 48000,
          type: 'pluck',
        )
        # system('play', file)
        found_note = find_note(file:)
        assert { found_note == note }
      end
    end

  end

end