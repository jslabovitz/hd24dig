class HD24Extractor

  module Commands

    class Info < SimpleCommand::Command

      def run(args)
        path = args.shift or raise
        @drive = HD24Extractor.open(path)
        @drive.print
      end

    end

  end

end