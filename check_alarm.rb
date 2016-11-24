# This is a simple executable ruby file meant to play some playlist.
require 'audite'
require 'data_mapper'

require_relative 'lib/models/alarm'

def get_today
  case DateTime.now.wday
    when 0
      :sunday
    when 1
      :monday
    when 2
      :tuesday
    when 3
      :wednesday
    when 4
      :thursday
    when 5
      :friday
    when 6
      :saturday
    else
      raise RuntimeError, 'This code should never run.'
  end
end

DataMapper.setup(:default, 'mysql://alarm:some_pass@localhost/AlarmClock')
DataMapper.finalize
DataMapper.auto_upgrade!



player = Audite.new

Alarm.all.each do |alarm|
  puts "#{alarm.start_date}"

  if alarm.should_sound?
    puts 'Alarm should sound!'
    player.load('/Users/andre/Desktop/audite_testing/playlist/linoleum.mp3')
    player.start_stream
    player.thread.join
    break
  end
end