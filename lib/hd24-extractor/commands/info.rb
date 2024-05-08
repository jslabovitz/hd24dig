module HD24Extractor

  module Commands

    class Info < Simple::CommandParser::Command

      def run(args)
        drive_path = args.shift or raise Simple::CommandParser::UsageError, "Must specify drive path"
        drive = HD24Extractor.open_drive(drive_path)
        drive.print
      end

    end

  end

end