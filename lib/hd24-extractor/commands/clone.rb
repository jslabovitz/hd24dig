module HD24Extractor

  module Commands

    class Clone < Command

      def run(args)
        super
        clone_path = args.shift or raise UsageError, "Must specify clone path"
        @drive.clone(to: clone_path)
      end

    end

  end

end