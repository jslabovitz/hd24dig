require 'bindata'
require 'path'
require 'set_params'
require 'simple-command-parser'
require 'tty-command'
require 'tty-table'
require 'tty-progressbar'
require 'tty-screen'

module HD24

  class UnexpectedData < StandardError; end

  def self.open_drive(path, drop_privileges: true)
    Drive.open(path).tap do
      if drop_privileges && ENV['SUDO_USER']   # running under sudo?
        Process::Sys.setgid(ENV['SUDO_GID'].to_i)
        Process::Sys.setuid(ENV['SUDO_UID'].to_i)
      end
    end
  end

end

require_relative 'hd24/duration'
require_relative 'hd24/file_system'
require_relative 'hd24/progress'

require_relative 'hd24/part'
require_relative 'hd24/drive'
require_relative 'hd24/project'
require_relative 'hd24/song'

require_relative 'hd24/records/drive_info'
require_relative 'hd24/records/file_allocation_info'
require_relative 'hd24/records/project_info'
require_relative 'hd24/records/song_info'
require_relative 'hd24/records/superblock'

require_relative 'hd24/commands/extract'
require_relative 'hd24/commands/info'