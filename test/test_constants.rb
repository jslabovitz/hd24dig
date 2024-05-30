require_relative '../lib/hd24dig'

module HD24Dig

  module TestConstants

    TMP_DIR = Path.new('test/tmp')
    DRIVE_IMAGE_FILE = Path.new('test/test.hd24').expand_path
    TEST_SETUP_FILE = Path.new('test/test_setup.rb')
    PITCH_BASE = Pitch.new_from_spn('C3')
    PITCH_INTERVAL = 1
    HARNESS_DIR = TMP_DIR / 'test-harness'
    MIDI_OUTPUT_DEVICE_NAME = 'ZOOM Corporation U-44'
    OUTPUT_TYPE = 'coreaudio'
    OUTPUT_NAME = 'ZOOM U-44 Driver'
    NUM_OUTPUT_CHANNELS = 2

  end

end