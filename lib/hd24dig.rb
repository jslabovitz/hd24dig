require 'bindata'
require 'path'
require 'set_params'
require 'simple-command-parser'
require 'tty-command'
require 'tty-table'
require 'tty-screen'

module HD24Dig

  class UnexpectedData < StandardError; end

  def self.open_drive(path, drop_privileges: true, clone: nil)
    Drive.open(path, clone:).tap do
      if drop_privileges && ENV['SUDO_USER']   # running under sudo?
        Process::Sys.setgid(ENV['SUDO_GID'].to_i)
        Process::Sys.setuid(ENV['SUDO_UID'].to_i)
      end
    end
  end

  def self.run_command(*args)
    $cmd ||= TTY::Command.new(printer: :quiet)
    # $cmd ||= TTY::Command.new()
    $cmd.run(*args.flatten.compact.map(&:to_s), only_output_on_error: true)
  end

  DUMP_PRINTABLE_BYTES = 32..127

  def self.dump_data(data, prefix: nil, output: STDOUT)
    0.step(by: 4, to: data.length - 1) do |offset|
      chunk = data[offset, 4]
      words = chunk.unpack('L*')
      bytes = chunk.bytes
      output.puts '%s+ 0x%04x         %s      %s      %s      %s      %s' % [
        prefix,
        offset,
        words.map { |w| '0x%08x' % w }.join(', '),
        words.map { |w| '%10d' % w }.join(', '),
        bytes.map { |b| '0x%02x' % b }.join(', '),
        bytes.map { |b| '%3d' % b }.join(', '),
        bytes.map { |b| DUMP_PRINTABLE_BYTES.include?(b) ? b.chr : '.' }.join,
      ]
    end
    output.puts
  end

end

require_relative 'hd24dig/duration'
require_relative 'hd24dig/file_system'

require_relative 'hd24dig/part'
require_relative 'hd24dig/channel'
require_relative 'hd24dig/drive'
require_relative 'hd24dig/project'
require_relative 'hd24dig/song'
require_relative 'hd24dig/track'

require_relative 'hd24dig/records/drive_info'
require_relative 'hd24dig/records/file_allocation_info'
require_relative 'hd24dig/records/locate_point_entry'
require_relative 'hd24dig/records/project_info'
require_relative 'hd24dig/records/song_info'
require_relative 'hd24dig/records/superblock'

require_relative 'hd24dig/commands/clone'
require_relative 'hd24dig/commands/extract'
require_relative 'hd24dig/commands/info'