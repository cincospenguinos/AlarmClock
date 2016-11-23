# This is a simple executable ruby file meant to play some playlist.
require_relative 'lib/alarm'

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

Alarm.all.each do |alarm|
  if alarm.should_sound?
    # TODO: Sound the alarm!
    break
  end
end