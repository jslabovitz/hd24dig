module HD24Extractor

  module Commands

    class Clone < Simple::CommandParser::Command

      def run(args)
        drive_path = args.shift or raise Simple::CommandParser::UsageError, "Must specify drive path"
        clone_path = args.shift or raise Simple::CommandParser::UsageError, "Must specify clone path"
        drive = HD24Extractor.open_drive(drive_path)
        drive.clone(to: clone_path)
      end

    end

  end

end