module HD24Dig

  module Commands

    class Extract < Simple::CommandParser::Command

      attr_accessor :projects
      attr_accessor :songs

      BAR_LABEL = ":info [:bar] "
      BAR_INFO_FORMAT = '%10s: %-80s'
      BAR_WIDTH = TTY::Screen.width - (BAR_INFO_FORMAT % ['', '']).length - 4

      def run(args)
        drive_path = args.shift or raise Simple::CommandParser::UsageError, "Must specify drive path"
        output_dir = Path.new(args.shift || '.')
        drive = HD24Dig.open_drive(drive_path)
        project_nums = @projects && @projects.to_s.split(',')&.map(&:to_i)
        song_nums = @songs && @songs.to_s.split(',')&.map(&:to_i)
        raise UsageError, "Project(s) must be specified if song(s) are specified" if song_nums && !project_nums
        bar = nil
        drive.extract_audio(dir: output_dir, project_nums:, song_nums:) do |progress|
          if progress.advance
            bar.advance(progress.advance, info: BAR_INFO_FORMAT % [progress.phase, progress.name])
          else
            bar&.stop
            bar = TTY::ProgressBar.new(BAR_LABEL, total: progress.total, width: BAR_WIDTH, clear: true)
          end
        end
        bar&.stop
      end

    end

  end

end