class HD24Extractor

  module Commands

    class Clone < SimpleCommand::Command

      def run(args)
        drive_path = args.shift or raise UsageError, "Must specify drive path"
        clone_path = args.shift or raise UsageError, "Must specify clone path"
        drive = HD24Extractor.open(drive_path)
        drive.clone(to: clone_path)
      end

    end

  end

end