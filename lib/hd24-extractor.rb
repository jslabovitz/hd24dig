require 'bindata'
require 'path'
require 'set_params'
require 'simple-command'
require 'simple-dumper'
require 'simple-printer'
require 'tty-progressbar'
require 'tty-screen'

module HD24Extractor

  class UnexpectedData < StandardError; end

end

require 'hd24-extractor/duration'
require 'hd24-extractor/file_system'

require 'hd24-extractor/part'
require 'hd24-extractor/drive'
require 'hd24-extractor/project'
require 'hd24-extractor/song'

require 'hd24-extractor/records/drive_info'
require 'hd24-extractor/records/file_allocation_info'
require 'hd24-extractor/records/project_info'
require 'hd24-extractor/records/song_info'
require 'hd24-extractor/records/superblock'

require 'hd24-extractor/command'
require 'hd24-extractor/commands/clone'
require 'hd24-extractor/commands/extract'
require 'hd24-extractor/commands/info'