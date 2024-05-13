module HD24

  module Commands

    class Info < Simple::CommandParser::Command

      def run(args)
        drive_path = args.shift or raise Simple::CommandParser::UsageError, "Must specify drive path"
        drive = HD24.open_drive(drive_path)
        drive.print_info
      end

    end

  end

end