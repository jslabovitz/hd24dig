# TODO

## Now

- Make progress bar dynamically sized.
- Build test drive, and update tests:
  - multiple named projects
  - multiple songs
  - songs at various resolutions and number of tracks
  - songs with multiple blocks (add to existing song after new song?)
  - deleted songs/projects
- Test on old Air.
- Revert gemspec references to local gems.
- Ensure all dependent gems are pushed/published:
  - simple_option_parser
  - simple-command
  - hashstruct
  - etc.
- Rename to 'hd24-extractor' / HD24Extractor / 'HD24 Extractor'


## Soon

- Write basic README.
  - Describe access to raw drive, via /dev/diskN.
    - Run as sudo (will drop access after opening file).
  - Difficulty in referring to project/song names/numbers.
- Push to Github.
- Push to Rubygems.
- Post announcment to hd24 list.

- Document classes.


## Later

- Allow specific tracks to be extracted.
- Allow songs/tracks to be extracted without creating directory hierary.
- Implement interactive mode.
- Design 'archive' format that only contains blocks actually in use.
  - Write sparse file?