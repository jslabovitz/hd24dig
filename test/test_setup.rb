HD24::Drive.new(
  name: 'Drive Name',
  projects: [
    HD24::Project.new(
      name: 'Proj Name',
      songs: [
        HD24::Song.new(
          name: 'Song Name',
          duration: '00:00:05:00',
          num_tracks: 24,
          sample_rate: 48000,
          sample_depth: 24,
        ),
        HD24::Song.new(
          name: 'Song Name',
          duration: '00:00:05:00',
          num_tracks: 24,
          sample_rate: 96000,
          sample_depth: 24,
        ),
      ],
    )
  ],
)