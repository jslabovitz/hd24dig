module HD24Dig

  module Commands

    class Info < Simple::CommandParser::Command

      def run(args)
        drive_path = args.shift or raise Simple::CommandParser::UsageError, "Must specify drive path"
        drive = HD24Dig.open_drive(Path.new(drive_path))
        drive.print_info
      end

    end

  end

end