module HD24

  module Commands

    class Extract < Command

      def run(args)
        super
        path = args.shift or raise
        @drive = HD24::Drive.open(path)
        #FIXME
        raise NotImplementedError, "Command not implemented"
      end

    end

  end

end