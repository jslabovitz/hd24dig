require 'bindata'
require 'path'
require 'set_params'
require 'simple-command'
require 'simple-dumper'
require 'simple-printer'
require 'tty-progressbar'

class HD24Extractor

  class UnexpectedData < StandardError; end

  def self.open(path)
    io = Path.new(path).open('rb')
    drop_privileges
    fs = FileSystem.new(io:)
    HD24Extractor::Parts::Drive.read(fs:, sector: 0)
  end

  def self.drop_privileges
    if ENV['SUDO_USER']   # running under sudo?
      # ;;warn 'dropping privileges'
      Process::Sys.setgid(ENV['SUDO_GID'].to_i)
      Process::Sys.setuid(ENV['SUDO_UID'].to_i)
    end
  end


end

require 'hd24-extractor/commands/extract'
require 'hd24-extractor/commands/info'

require 'hd24-extractor/duration'
require 'hd24-extractor/file_system'

require 'hd24-extractor/records/drive_info'
require 'hd24-extractor/records/file_allocation_info'
require 'hd24-extractor/records/project_info'
require 'hd24-extractor/records/song_info'
require 'hd24-extractor/records/superblock'

require 'hd24-extractor/part'
require 'hd24-extractor/parts/drive'
require 'hd24-extractor/parts/project'
require 'hd24-extractor/parts/song'