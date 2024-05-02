$VERBOSE = false

require 'minitest/autorun'
require 'minitest/power_assert'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'hd24'

class HD24::Test < Minitest::Test

  IMAGE_PATH = '~/Projects/audio:video/studio/work/hd24-images/main-backup-1.img'
  TMP_PATH = 'test/tmp'

  def setup
    FileUtils.rm_rf(TMP_PATH) if File.exist?(TMP_PATH)
    Dir.mkdir(TMP_PATH)
    @drive = HD24.open(File.expand_path(IMAGE_PATH))
    @project = @drive.projects.first
  end

  def test_drive
    drive_name = @drive.name
    assert { drive_name == 'Drive Name' }
  end

  def test_project
    assert { @project != nil }
    project_name = @project.name
    assert { project_name == 'Proj Name' }
  end

  EXPECTED_SONGS = [

    # {:num=>1, :name=>"Song Name", :duration=>17, :num_tracks=>12, :sample_rate=>96000}
    {
      name: 'Song Name',
      duration: [0, 0, 17, 0],
      num_tracks: 12,
      sample_rate: 96000,
    },
    # {:num=>2, :name=>"Drum Bed", :duration=>112, :num_tracks=>8, :sample_rate=>48000}
    {
      name: 'Drum Bed',
      duration: [0, 1, 52, 21],
      num_tracks: 8,
      sample_rate: 48000,
    },
    # {:num=>3, :name=>"Pandemime", :duration=>39, :num_tracks=>8, :sample_rate=>96000}
    {
      name: 'Pandemime',
      duration: [0, 1, 19, 27],
      num_tracks: 8,
      sample_rate: 96000,
    },
    # {
    #   name: 'Song Name',
    #   duration: [0, 0, 34, 04],
    #   num_tracks: 12,
    #   sample_rate: 96000,
    # },
    # {:num=>4, :name=>"T58 1", :duration=>33, :num_tracks=>8, :sample_rate=>96000}
    {
      name: 'T58 1',
      duration: [0, 1, 7, 25],
      num_tracks: 8,
      sample_rate: 96000,
    },
    # {:num=>5, :name=>"T58 2", :duration=>32, :num_tracks=>8, :sample_rate=>96000}
    {
      name: 'T58 2',
      duration: [0, 1, 4, 11],
      num_tracks: 8,
      sample_rate: 96000,
    },
    # {:num=>6, :name=>"T58 3", :duration=>123, :num_tracks=>8, :sample_rate=>96000}
    {
      name: 'T58 3',
      duration: [0, 4, 7, 8],
      num_tracks: 8,
      sample_rate: 96000,
    },
    # {:num=>7, :name=>"Vestax 1", :duration=>36, :num_tracks=>8, :sample_rate=>96000}
    {
      name: 'Vestax 1',
      duration: [0, 1, 13, 9],
      num_tracks: 8,
      sample_rate: 96000,
    },
    # {:num=>8, :name=>"Vestax 2", :duration=>95, :num_tracks=>8, :sample_rate=>96000}
    {
      name: 'Vestax 2',
      duration: [0, 3, 10, 18],
      num_tracks: 8,
      sample_rate: 96000,
    },
    # {:num=>9, :name=>"Vestax 4", :duration=>54, :num_tracks=>8, :sample_rate=>96000}
    {
      name: 'Vestax 4',
      duration: [0, 1, 48, 13],
      num_tracks: 8,
      sample_rate: 96000,
    },
    # {:num=>10, :name=>"Vestax 6", :duration=>34, :num_tracks=>8, :sample_rate=>96000}
    {
      name: 'Vestax 6',
      duration: [0, 1, 8, 13],
      num_tracks: 8,
      sample_rate: 96000,
    },
    # {:num=>11, :name=>"GB 1", :duration=>55, :num_tracks=>16, :sample_rate=>44100}
    {
      name: 'GB 1',
      duration: [0, 0, 55, 28],
      num_tracks: 16,
      sample_rate: 44100,
    },
    # {:num=>12, :name=>"GB 2", :duration=>56, :num_tracks=>16, :sample_rate=>44100}
    {
      name: 'GB 2',
      duration: [0, 0, 56, 19],
      num_tracks: 16,
      sample_rate: 44100,
    },
    # {:num=>13, :name=>"GB 3", :duration=>50, :num_tracks=>16, :sample_rate=>44100}
    {
      name: 'GB 3',
      duration: [0, 0, 50, 2],
      num_tracks: 16,
      sample_rate: 44100,
    },
    # {:num=>14, :name=>"GB 5", :duration=>18, :num_tracks=>16, :sample_rate=>44100}
    {
      name: 'GB 5',
      duration: [0, 0, 18, 23],
      num_tracks: 16,
      sample_rate: 44100,
    },
    # {:num=>15, :name=>"GB 6", :duration=>55, :num_tracks=>16, :sample_rate=>44100}
    {
      name: 'GB 6',
      duration: [0, 0, 55, 24],
      num_tracks: 16,
      sample_rate: 44100,
    },
    # {:num=>16, :name=>"GB 7", :duration=>89, :num_tracks=>8, :sample_rate=>44100}
    {
      name: 'GB 7',
      duration: [0, 1, 29, 20],
      num_tracks: 8,
      sample_rate: 44100,
    },
    # {:num=>17, :name=>"GB 8", :duration=>57, :num_tracks=>8, :sample_rate=>44100}
    {
      name: 'GB 8',
      duration: [0, 1, 57, 13],
      num_tracks: 8,
      sample_rate: 44100,
    },
    # {:num=>18, :name=>"GB 9", :duration=>223, :num_tracks=>8, :sample_rate=>44100}
    {
      name: 'GB 9',
      duration: [0, 3, 43, 8],
      num_tracks: 8,
      sample_rate: 44100,
    },
    # {:num=>19, :name=>"GB 10", :duration=>132, :num_tracks=>8, :sample_rate=>44100}
    {
      name: 'GB 10',
      duration: [0, 2, 12, 29],
      num_tracks: 8,
      sample_rate: 44100,
    },
    # {:num=>20, :name=>"SG-Tact 2", :duration=>938, :num_tracks=>2, :sample_rate=>96000}
    {
      name: 'SG-Tact 2',
      duration: [0, 31, 16, 23],
      num_tracks: 2,
      sample_rate: 96000,
    },
    # {:num=>21, :name=>"SG-Tact 1", :duration=>850, :num_tracks=>2, :sample_rate=>96000}
    {
      name: 'SG-Tact 1',
      duration: [0, 28, 20, 13],
      num_tracks: 2,
      sample_rate: 96000,
    },
    # {:num=>22, :name=>"TZFP 1 #4", :duration=>555, :num_tracks=>2, :sample_rate=>96000}
    {
      name: 'TZFP 1 #4',
      duration: [0, 18, 31, 28],
      num_tracks: 2,
      sample_rate: 96000,
    },
    # {:num=>23, :name=>"TZFP 1 #2", :duration=>829, :num_tracks=>2, :sample_rate=>96000}
    {
      name: 'TZFP 1 #2',
      duration: [0, 27, 38, 23],
      num_tracks: 2,
      sample_rate: 96000,
    },
    # {:num=>24, :name=>"TZFP 1 #1", :duration=>856, :num_tracks=>2, :sample_rate=>96000}
    {
      name: 'TZFP 1 #1',
      duration: [0, 28, 33, 27],
      num_tracks: 2,
      sample_rate: 96000,
    },
    # {:num=>25, :name=>"TZFP #3", :duration=>801, :num_tracks=>2, :sample_rate=>96000}
    {
      name: 'TZFP #3',
      duration: [0, 26, 43, 18],
      num_tracks: 2,
      sample_rate: 96000,
    },
    # {:num=>26, :name=>"Song Name", :duration=>41, :num_tracks=>12, :sample_rate=>96000}
    {
      name: 'Song Name',
      duration: [0, 1, 22, 5],
      num_tracks: 12,
      sample_rate: 96000,
    },
    # {:num=>27, :name=>"J momma", :duration=>50, :num_tracks=>16, :sample_rate=>44100}
    {
      name: 'J momma',
      duration: [0, 0, 50, 23],
      num_tracks: 16,
      sample_rate: 44100,
    },
    # {:num=>28, :name=>"Song Name", :duration=>0, :num_tracks=>24, :sample_rate=>48000}
    {
      name: 'Song Name',
      duration: [0, 0, 39, 0],
      num_tracks: 24,
      sample_rate: 48000,
    },
  ]

  def test_songs
    num_songs = @project.songs.count
# ;;pp @project.songs.each_with_index.map { |s, i| [s.name, i] }
    assert { num_songs == EXPECTED_SONGS.count }
    @project.songs.each_with_index do |song, i|
# ;;pp(i => song.name)
      expected = EXPECTED_SONGS[i]
      name, duration, sample_rate = song.name, song.duration, song.sample_rate
      assert { name == expected[:name] }
      expected_duration = HD24::Duration.from_array(expected[:duration])
      # assert { duration.to_seconds.to_i == expected_duration.to_seconds.to_i }
      assert { sample_rate == expected[:sample_rate] }
      track_paths = song.extract_audio(File.join(TMP_PATH, song.num.to_s))
      assert { track_paths.length == expected[:num_tracks] }
      track_paths.each do |path|
        assert { File.exist?(path) }
      end
      ;;break
    end
  end

end