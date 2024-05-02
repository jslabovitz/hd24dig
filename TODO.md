# TODO

## Now

- Make 'extract' command to extract projects/songs/tracks.
- Build test drive, and update tests:
  - multiple named projects
  - multiple songs
  - songs at various resolutions and number of tracks
  - songs with multiple blocks (add to existing song after new song?)
  - deleted songs/projects
- Test on old Air.
- Write basic README.
  - Describe access to /dev/diskN.
    - Run as sudo (will drop access after opening file).
- Revert gemspec references to local gems.
- Rename to 'hd24-extractor' / HD24Extractor / 'HD24 Extractor'
- Push to Github.


## Soon

- Push to Rubygems.
- Post announcment to hd24 list.
- Document classes.
- Write WAV files natively.
  http://dracoater.blogspot.com/2008/11/comparing-2-audio-wav-files.html?m=1
  https://stackoverflow.com/questions/48098254/append-pcm-audio-raw-data-into-wav-in-c?rq=1
  https://stackoverflow.com/questions/19897879/converting-pcm-to-wav-file
  https://stackoverflow.com/questions/53417630/creating-a-wav-file-from-pcm-data
    - Write multichannel format as option?


## Later

- Show extraction progress with tty-progress.
    https://github.com/piotrmurach/tty-progressbar
- Implement interactive mode.
- Design 'distilled' format that only contains blocks actually in use.
  - First part of file has sector index.
  - Can be run on connected drive, then later operations work on distilled format.
- Make C version.
- Make FUSE driver.