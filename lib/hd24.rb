require 'bindata'
require 'set_params'
require 'simple-command'
require 'simple-dumper'
require 'simple-printer'

class HD24

  class UnexpectedData < StandardError; end

  SECTOR_SIZE = 512

  def self.open(path)
    io = File.open(path, 'rb')
    drop_privileges
    fs = FileSystem.new(io:)
    HD24::Parts::Drive.read(fs:, sector: 0)
  end

  def self.drop_privileges
    if ENV['SUDO_USER']   # running under sudo?
      # ;;warn 'dropping privileges'
      Process::Sys.setgid(ENV['SUDO_GID'].to_i)
      Process::Sys.setuid(ENV['SUDO_UID'].to_i)
    end
  end


end

require 'hd24/commands/extract'
require 'hd24/commands/info'

require 'hd24/duration'
require 'hd24/file_system'

require 'hd24/records/drive_info'
require 'hd24/records/file_allocation_info'
require 'hd24/records/project_info'
require 'hd24/records/song_info'
require 'hd24/records/superblock'

require 'hd24/part'
require 'hd24/parts/drive'
require 'hd24/parts/project'
require 'hd24/parts/song'