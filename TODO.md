# TODO

## Now

- Make FileSystem.new/.open work like File.
- Fix 'num_tracks' -- divide by 2 if high-res?
- Test with high-res files (12 tracks @ 96kHz).
- Make 'extract' command to extract projects/songs/tracks.
- Revert gemspec references to local gems.
- Test on old Air.
- Test with direct drive connection.
- Write basic README.


## Soon

- Push to Github.
- Post announcment to hd24 list.
- Document classes.
- Build test drive:
  - multiple named projects
  - multiple songs
  - songs at various resolutions and number of tracks
  - songs with multiple blocks (add to existing song after new song?)
  - deleted songs/projects
- Improve tests to check for above.
- Write WAV files natively.
  - Write multichannel format as option?
- Show extraction progress with tty-progress.
    https://github.com/piotrmurach/tty-progressbar
- Implement interactive mode.


## Later

- Design 'distilled' format that only contains blocks actually in use.
  - First part of file has sector index.
  - Can be run on connected drive, then later operations work on distilled format.
- Make C version.
- Make FUSE driver.