require 'irb/completion'

IRB.conf[:USE_READLINE] = true
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:AUTO_INDENT]  = true

<<EOS.tap{|s| puts s}.tap{|s| eval(s)}
require 'rubygems'
require 'pp'
require 'time'
EOS