require 'irb/completion'

IRB.conf[:USE_READLINE] = true
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:AUTO_INDENT]  = true

<<EOS.tap{|s| puts s}.tap{|s| eval(s)}
require 'rubygems'
require 'pp'
require 'time'
require 'base64'
require 'nkf'
EOS

module Kernel
  def pbcopy(str)
    IO.popen("pbcopy", "r+") do |io|
      io.print(str)
      io.close_write
    end
    str
  end
  def pbpaste
    `pbpaste`
  end
  module_function :pbcopy, :pbpaste
end
class String
  def pbcopy
    Kernel.pbcopy(self)
  end
end
