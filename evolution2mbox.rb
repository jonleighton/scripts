# Takes a load of messages from an Evolution IMAP directory and morphs them into
# an mbox file, so that they can, er, be imported into Evolution!

require "time"

messages = Dir[File.dirname(__FILE__) + "/*."].map { |message| File.read(message) }
messages = messages.map do |message|
  from = message[/^From: .*$/]
  from_email = from[/<[^>]+>/][1..-2]
  date = Time.parse(message[/^Date: .*$/][6..-1])
  
  "From #{from_email} #{date.asctime}\n" + message
end

puts messages.join
