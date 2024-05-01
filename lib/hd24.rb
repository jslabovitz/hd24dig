require 'bindata'
require 'set_params'
require 'simple-command'
require 'simple-printer'

class HD24

  class UnexpectedData < StandardError; end

  def self.open(path)
    fs = FileSystem.open(path)
    HD24::Parts::Drive.read(fs:, sector: 0)
  end

end

require 'hd24/command'
require 'hd24/commands/extract'
require 'hd24/commands/info'

require 'hd24/file_system'

require 'hd24/records/drive_info'
require 'hd24/records/project_info'
require 'hd24/records/song_info'
require 'hd24/records/superblock'

require 'hd24/part'
require 'hd24/parts/drive'
require 'hd24/parts/project'
require 'hd24/parts/song'