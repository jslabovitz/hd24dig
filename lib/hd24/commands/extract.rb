class HD24

  module Commands

    class Extract < SimpleCommand::Command

      attr_accessor :output_dir
      attr_accessor :projects
      attr_accessor :songs

      def run(args)
        @output_dir = Path.new(@output_dir || '.')
        @projects = @projects.to_s.split(',')&.map(&:to_i) if @projects
        @songs = @songs.to_s.split(',')&.map(&:to_i) if @songs
        raise SimpleCommand::UsageError, "Project must be specified if songs are specified" if @songs && !@projects
        drive_path = Path.new(ARGV.first).expand_path
        drive = HD24.open(drive_path)
        drive.projects.each do |project|
          next if @projects && !@projects.include?(project.num)
          project.songs.each do |song|
            next if @songs && !@songs.include?(song.num)
            dir = @output_dir.join(project.name, '%02d - %s' % [song.num, song.name])
            dir.mkpath
            bar = TTY::ProgressBar.new("extracting: :name :phase :bar ",
              total: song.total_extraction_steps,
              width: 50)
            song.extract_audio(dir) do |phase|
              bar.advance(name: '%-64s' % dir.relative_to(@output_dir).to_s, phase: phase.to_s)
            end
          end
        end
      end

    end

  end

end