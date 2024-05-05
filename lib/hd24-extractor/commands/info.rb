class HD24Extractor

  module Commands

    class Info < Command

      def run(args)
        super
        @drive.print
      end

    end

  end

end