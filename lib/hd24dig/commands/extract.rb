module HD24Dig

  module Commands

    class Extract < Simple::CommandParser::Command

      attr_accessor :projects
      attr_accessor :songs

      def run(args)
        drive_path = args.shift or raise Simple::CommandParser::UsageError, "Must specify drive path"
        output_dir = Path.new(args.shift || '.')
        drive = HD24Dig.open_drive(Path.new(drive_path))
        project_nums = @projects && @projects.to_s.split(',')&.map(&:to_i)
        song_nums = @songs && @songs.to_s.split(',')&.map(&:to_i)
        raise UsageError, "Project(s) must be specified if song(s) are specified" if song_nums && !project_nums
        drive.extract_audio(dir: output_dir, project_nums:, song_nums:)
      end

    end

  end

end