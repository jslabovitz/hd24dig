HD24::Drive.new(
  name: 'Drive Name',
  projects: [
    HD24::Project.new(
      name: 'Proj Name',
      songs: [
        HD24::Song.new(
          name: 'Song Name',
          duration: '00:00:07:12',
          num_tracks: 8,
          sample_rate: 48000,
          sample_depth: 24,
        ),
      ],
    )
  ],
)