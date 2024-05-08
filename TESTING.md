# Testing notes

## Set up HD24

- Confirm OS version (1.21)
- Set up MIDI
  - Press MIDI button
    - 'Send MMC?' -> Yes
  - Connect MIDI IN/OUT to MIDI interface #4
  - NOTE: Sends to all channels, all devices
    - probably want to disconnect other MIDI devices
- Hold down INPUT SELECT and press arm button for track 24
- Press INPUT SELECT until INPUT reads DIGITAL
- ??? Push AUTO INPUT until MONITOR reads AUTO
- ??? Push ALL INPUT until MONITOR reads ALL


## Record test harness

- Quick format HD
- Connect Mac to MIDI interface
- Run 'bundle exec tools/test-harness'