module HD24

  module Commands

    class Extract < Simple::CommandParser::Command

      attr_accessor :projects
      attr_accessor :songs

      def run(args)
        drive_path = args.shift or raise Simple::CommandParser::UsageError, "Must specify drive path"
        output_dir = Path.new(args.shift || '.')
        drive = HD24.open_drive(drive_path)
        @projects = @projects.to_s.split(',')&.map(&:to_i) if @projects
        @songs = @songs.to_s.split(',')&.map(&:to_i) if @songs
        raise UsageError, "Project must be specified if songs are specified" if @songs && !@projects
        bar_width = TTY::Screen.width - 91  # adjust for bar definition below
        drive.projects.each do |project|
          next if @projects && !@projects.include?(project.num)
          project.songs.each do |song|
            next if @songs && !@songs.include?(song.num)
            dir = output_dir.join(drive.name, project.name, '%02d - %s' % [song.num, song.name])
            dir.mkpath
            bar = TTY::ProgressBar.new("extracting: :name :phase [:bar] ",
              total: song.total_extraction_steps,
              width: bar_width)
            song.extract_audio(dir) do |phase|
              bar.advance(name: '%-64s' % dir.relative_to(output_dir).to_s, phase: phase.to_s)
            end
          end
        end
      end

    end

  end

end