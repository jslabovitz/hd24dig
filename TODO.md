# TODO

## Now

- Make 'extract' command take arguments for specific projects/songs/tracks.
- Make progress bar dynamically sized.
- Build test drive, and update tests:
  - multiple named projects
  - multiple songs
  - songs at various resolutions and number of tracks
  - songs with multiple blocks (add to existing song after new song?)
  - deleted songs/projects
- Test on old Air.
- Write basic README.
  - Describe access to raw drive, via /dev/diskN.
    - Run as sudo (will drop access after opening file).
- Revert gemspec references to local gems.
- Rename to 'hd24-extractor' / HD24Extractor / 'HD24 Extractor'


## Soon

- Push to Github.
- Push to Rubygems.
- Post announcment to hd24 list.
- Document classes.


## Later

- Implement interactive mode.
- Design 'distilled' format that only contains blocks actually in use.
  - First part of file has sector index.
  - Can be run on connected drive, then later operations work on distilled format.
- Make C version.
- Make FUSE driver.