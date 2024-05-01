class HD24

  module Commands

    class Info < SimpleCommand::Command

      def run(args)
        path = args.shift or raise
        @drive = HD24.open(path)
        @drive.print
      end

    end

  end

end