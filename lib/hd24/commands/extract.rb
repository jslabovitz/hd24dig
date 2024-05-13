module HD24

  module Commands

    class Extract < Simple::CommandParser::Command

      attr_accessor :projects
      attr_accessor :songs

      def run(args)
        drive_path = args.shift or raise Simple::CommandParser::UsageError, "Must specify drive path"
        output_dir = Path.new(args.shift || '.')
        drive = HD24.open_drive(drive_path)
        project_nums = @projects && @projects.to_s.split(',')&.map(&:to_i)
        song_nums = @songs && @songs.to_s.split(',')&.map(&:to_i)
        raise UsageError, "Project(s) must be specified if song(s) are specified" if song_nums && !project_nums
        bar_label = "extracting: :name :phase [:bar] "
        bar_width = TTY::Screen.width - 91  # adjust as needed
        bar = song = phase = nil
        drive.extract_audio(dir: output_dir, project_nums:, song_nums:) do |progress|
          if progress.song != song || progress.phase != phase
            bar&.stop
            bar = TTY::ProgressBar.new(bar_label, total: progress.total, width: bar_width, clear: true)
            song, phase = progress.song, progress.phase
          end
          bar.advance(progress.advance, name: '%-64s' % song.full_name, phase: progress.phase.to_s)
        end
        bar&.stop
      end

    end

  end

end