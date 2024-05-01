class HD24

  module Parts

    class Project < Part

      attr_accessor :num
      attr_accessor :songs

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

      def read(sector:)
        @project_info = @fs.read_sector(sector, as: Records::ProjectInfo, dump: false)
        @songs = @project_info.song_info_table.reject(&:zero?).each_with_index.map do |song_sector, song_num|
          Song.read(fs: @fs, sector: song_sector, num: song_num)
        end
      end

    end

  end

end