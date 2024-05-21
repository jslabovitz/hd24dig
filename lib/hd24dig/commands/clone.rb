module HD24Dig

  module Commands

    class Clone < Simple::CommandParser::Command

      def run(args)
        in_drive_path = args.shift or raise Simple::CommandParser::UsageError, "Must specify input drive path"
        out_drive_path = args.shift or raise Simple::CommandParser::UsageError, "Must specify output drive path"
        drive = HD24Dig.open_drive(Path.new(in_drive_path), clone: Path.new(out_drive_path))
        drive.clone
      end

    end

  end

end