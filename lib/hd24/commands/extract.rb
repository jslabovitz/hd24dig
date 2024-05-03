class HD24

  module Commands

    class Extract < SimpleCommand::Command

      def run(args)
        drive_path = Path.new(ARGV.first).expand_path
        #FIXME: make configurable
        output_dir = Path.new('/tmp/hd24')
        # raise if output_dir.exist?
        drive = HD24.open(drive_path)
        drive.projects.each do |project|
          project.songs.each do |song|
            name, duration, sample_rate = song.name, song.duration, song.sample_rate
            dir = output_dir / drive.name / project.name / ('Song %02d - %s' % [song.num, song.name])
            song.extract_audio(dir, show_progress: true)
          end
        end
      end

    end

  end

end