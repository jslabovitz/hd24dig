# TODO

## Now

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
  - Difficulty in referring to project/song names/numbers.


## Soon

- Push to Github.
- Push to Rubygems.
- Post announcment to hd24 list.


## Later

- Document classes.
- Allow specific tracks to be extracted.
- Allow songs/tracks to be extracted without creating directory hierary.
- Implement interactive mode.
- Design 'archive' format that only contains blocks actually in use.
  - Write sparse file?