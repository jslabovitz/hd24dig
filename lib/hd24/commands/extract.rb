class HD24

  module Commands

    class Extract < SimpleCommand::Command

      def run(args)
        drive_path = Path.new(ARGV.first).expand_path
        #FIXME: make configurable
        output_dir = Path.new('/tmp/hd24')
        drive = HD24.open(drive_path)
        drive.projects.each do |project|
          project.songs.each do |song|
            name, duration, sample_rate = song.name, song.duration, song.sample_rate
            song_path = 'Song %02d - %s' % [song.num, song.name]
            dir = output_dir / drive.name / project.name / song_path
            full_name = [drive.name, project.name, song.name].join(' / ')
            bar = TTY::ProgressBar.new("extracting: :name :bar ",
              total: song.total_blocks,
              width: 50)
            song.extract_audio(dir) do |sector, block_num|
              bar.advance(name: '%-64s' % full_name)
            end
          end
        end
      end

    end

  end

end