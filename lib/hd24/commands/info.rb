module HD24

  module Commands

    class Info < Command

      def run(args)
        super
        path = args.shift or raise
        @drive = HD24::Drive.open(path)
        @drive.show_info
      end

    end

  end

end