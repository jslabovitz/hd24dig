class HD24

  module Parts

    class Project < Part

      attr_accessor :songs

      def printable
        [
          :name,
          :songs,
        ]
      end

      def name
        @project_info.project_name
      end

      def read(fs:, sector:)
        @project_info = fs.read_sector(sector, as: Records::ProjectInfo, dump: false)
        @songs = @project_info.song_info_table.reject(&:zero?).map do |song_sector|
          Song.read(fs:, sector: song_sector)
        end
      end

    end

  end

end