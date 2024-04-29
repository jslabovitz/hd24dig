module HD24

  module Commands

    class Read < Command

      def run(args)
        super
        path = args.shift or raise
        @drive = HD24::Drive.open(path)
        @drive.show
      end

    end

  end

end