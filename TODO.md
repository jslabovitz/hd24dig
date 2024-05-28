# TODO


## Now

- Figure out why some tracks in hi-res songs seem cut off at beginning.
  - FTP all tracks and compare with extracted tracks.
- Remove local gem references from Gemfile.
  - push/publish midi-mmc, pitch, tone-gen
- Make Parts module and move all parts under it.


## Soon

- Finish README.
- Add license.
- Push to Github.
- Release to Rubygems.
- Post announcment to hd24 list.


## Later

- Expand test harness & tests.
  - multiple named projects
  - multiple songs
  - songs at various resolutions and number of tracks
  - songs with multiple blocks -- esp. after new song!
    - add new tracks to existing song
    - add new audio to existing song
  - move song to project
  - delete songs/projects
  - songs with all tracks full of content
    - debug tracks that have empty audio after ~15s?
- Document classes.
- Allow specific tracks to be extracted.
- Allow songs/tracks to be extracted without creating directory hierary.
- Skip empty tracks/songs/projects.
- Implement interactive mode.