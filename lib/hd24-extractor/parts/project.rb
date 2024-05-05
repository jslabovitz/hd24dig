module HD24Extractor

  module Parts

    class Project < Part

      attr_accessor :num
      attr_accessor :drive

      def printable
        [
          [:num, 'Number'],
          :name,
          :songs,
        ]
      end

      def name
        @project_info.project_name
      end

      def songs
        @songs ||= @project_info.song_info_table.reject(&:zero?).each_with_index.map do |song_sector, song_idx|
          Song.read(fs: @fs, sector: song_sector, num: song_idx + 1, project: self)
        end
      end

      def read
        @project_info = @fs.read(sector: @sector, as: Records::ProjectInfo)
        @sector_range = Range.new(@sector, @sector)
      end

      def each_used_sector_range(&block)
        yield(@sector_range)
        songs.each do |song|
          song.each_used_sector_range(&block)
        end
      end

    end

  end

end