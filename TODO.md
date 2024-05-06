# TODO

## Now

- Build test drive, and update tests:
  - multiple named projects
  - multiple songs
  - songs at various resolutions and number of tracks
  - songs with multiple blocks -- esp. after new song!
    - add new tracks to existing song
    - add new audio to existing song
  - deleted songs/projects
  - songs with all tracks full of content
    - debug tracks that have empty audio after ~15s?
- Test on old Air.
- Make usage/help output.
  - Ensure UsageError actually works.
- Write basic README.
  - Describe access to raw drive, via /dev/diskN.
    - Run as sudo (will drop access after opening file).
  - Difficulty in referring to project/song names/numbers.


## Soon

- Push to Github.
- Release to Rubygems.
- Post announcment to hd24 list.


## Later

- Document classes.
- Allow specific tracks to be extracted.
- Allow songs/tracks to be extracted without creating directory hierary.
- Skip empty tracks/songs/projects.
- Implement interactive mode.