class HD24

  module Commands

    class Info < Command

      def run(args)
        super
        path = args.shift or raise
        @drive = HD24.open(path)
        @drive.print
      end

    end

  end

end