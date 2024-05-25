# Testing notes


## Building a test rig

Needed components:

- Mac (or maybe Linux) computer
- IDE/USB interface for reading HD24 drive
- USB hub (optional)
- HD24 with hard drive for testing
- audio interface with 2-24 output channels
- audio cables to connect interface with HD24 (one per channel)
- Ethernet cable (+ Ethernet/USB adapter for computer if needed)
- MIDI interface
- MIDI cables (2)

Note that if you want to test both low-resolution (48kHz) and high-resolution (96kHz), you will need to either use an HD24XR, or an HD24 with a audio interface connected by ADAT+SMUX, and have the HD24 in DIGITAL input mode.

## Building test harness

Check out source repository and install dependencies:

    git clone FIXME
    bundle update

To build the test harness, type:

    rake build_test_harness

Connect an HD24 as described in the listed steps. Then copy the image file to FIXME.


## Set up computer

- Connect to MIDI interface via USB
- Connect to audio interface via USB

- Find name of audio interface

    sox -V6 -n -t coreaudio junkname

- Share Internet with Ethernet
  
  - set address on Mac manually to 192.168.2.1
  - set HD24:
    - address: 192.168.002.100
    - mask: 255.255.255.000
    - gateway: 000.000.000.000

- Modify tools/test-harness for above

## Set up HD24

- Connect MIDI IN/OUT to MIDI interface channel #4 OUT/IN
- Connect audio interface analog L/R outputs to channels 1/2
- Eject production drive(s) and insert test drive
- Power on
- Hold down INPUT SELECT and press arm button for track 2
- Set INPUT SELECT to ANALOG
- Set AUTO INPUT to OFF
- Set ALL INPUT to OFF
- Quick format HD


## Record test tones


## Update test/test_setup.rb

Change durations to match actual durations on HD24.


## Finish up

- Press DRIVE button to dismount test drive
- Reset input normaling & monitoring


## Copy to computer

- Remove drive from HD24
- Insert into drive dock
- Answer 'Ignore' to macOS prompt about unknown disk
- FIXME: determine device name (/dev/disk4)
- `sudo chmod go+r /dev/disk4`
- FIXME: ... copy ...