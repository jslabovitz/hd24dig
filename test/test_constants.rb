require 'path'
require 'pitch'

require_relative '../lib/hd24dig'

module HD24Dig

  module TestConstants

    TEST_DIR = Path.new('test')
    TMP_DIR = TEST_DIR / 'tmp'
    DRIVE_IMAGE_FILE = TEST_DIR / 'test.hd24'
    TEST_SETUP_FILE = TEST_DIR / 'test_setup.rb'
    PITCH_BASE = Pitch.new_from_spn('C3')
    PITCH_INTERVAL = 1
    HARNESS_DIR = TMP_DIR / 'harness'
    MIDI_OUTPUT_DEVICE_NAME = 'ZOOM Corporation U-44'
    OUTPUT_TYPE = 'coreaudio'
    OUTPUT_NAME = 'ZOOM U-44 Driver'
    NUM_OUTPUT_CHANNELS = 2
    FTP_DIR = TEST_DIR / 'ftp'
    EXTRACT_DIR = TMP_DIR / 'extract'

  end

end