module HD24Extractor

  module Commands

    class Info < Simple::CommandParser::Command

      HEADER = {
        'project #' => :right,
        'song #' => :right,
        'drive' => :left,
        'project' => :left,
        'song' => :left,
        'duration' => :left,
        'tracks' => :right,
        'resolution' => :left,
      }

      def run(args)
        drive_path = args.shift or raise Simple::CommandParser::UsageError, "Must specify drive path"
        drive = HD24Extractor.open_drive(drive_path)
        table = TTY::Table.new(header: HEADER.keys)
        drive.projects.each do |project|
          project.songs.each do |song|
            table << [
              project.num,
              song.num,
              drive.name,
              project.name,
              song.name,
              song.duration,
              song.num_effective_tracks,
              song.resolution_str,
            ]
          end
        end
        puts table.render(:unicode,
          padding: [0, 1],
          alignments: HEADER.values.map { |a| a || :left },
        )
      end

    end

  end

end