module HD24Dig

  module Parts

    class Project < Part

      ATTRS = %i[
        songs
      ]
      attr_accessor *ATTRS
      attr_accessor :drive

      def initialize(**)
        @songs = []
        super
      end

      def comparable_attributes
        super + ATTRS
      end

      def inspectable_attributes
        super + ATTRS
      end

      def songs=(songs)
        @songs = []
        songs.each { |s| add_song(s) }
      end

      def add_song(song)
        song = Song.new(**song) if song.kind_of?(Hash)
        song.num = @songs.length + 1
        song.project = self
        @songs << song
      end

      def read(sector)
        project_info = read_record(Records::ProjectInfo, sector:)
        @name = project_info.project_name
        project_info.song_info_sectors.each do |song_sector|
          add_song(Song.read(fs: @fs, sector: song_sector))
        end
      end

    end

  end

end