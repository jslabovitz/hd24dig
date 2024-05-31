$VERBOSE = false

require 'minitest/autorun'
require 'minitest/power_assert'

require_relative '../lib/hd24dig'
require_relative 'test_constants'

module HD24Dig

  module TestHelpers

    include TestConstants

    SOX_PARAMS = [
      '--type', 'raw',
      '--encoding', 'signed-integer',
      '--bits', 24,
    ]

    def pcm_files_equivalent?(file1, file2)
      file1_pcm = file1.replace_extension('.pcm')
      file2_pcm = file2.replace_extension('.pcm')
      HD24Dig.run_command('sox', file1, SOX_PARAMS, file1_pcm) or raise "Can't convert #{file1} to #{file1_pcm}"
      HD24Dig.run_command('sox', file2, SOX_PARAMS, file2_pcm) or raise "Can't convert #{file2} to #{file2_pcm}"
      HD24Dig.run_command('cmp', file1_pcm, file2_pcm) or warn "different: #{file2_pcm} != #{file1_pcm}"
    end

    def file_duration(file)
      out, _ = HD24Dig.run_command('soxi', '-D', file)
      Duration.new(out.to_f)
    end

  end

end