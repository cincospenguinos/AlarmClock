require 'data_mapper'
require 'dm-types'

class AlarmClock
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :start_date, DateTime, :required => true
  property :repeat, Json, :default => []
  property :is_on, Boolean, :default => true

  ## Add a day of the week that this alarm should be repeated
  def add_weekly_repeat(day_of_week)
    return false unless validate_day_of_week(day_of_week)
    self.repeat.push(day_of_week) unless has_weekly_repeat(day_of_week)
    save
    true
  end

  ## True if the day of the week passed is included as a day to repeat this alarm
  def has_weekly_repeat(day_of_week)
    return false unless validate_day_of_week(day_of_week)
    save
    self.repeat.include?(day_of_week.to_s) || self.repeat.include?(day_of_week)
  end

  ## Removes the day of week passed
  def remove_weekly_repeat(day_of_week)
    return false unless validate_day_of_week(day_of_week)
    self.repeat.delete(day_of_week)
    save
    true
  end

  ## Toggles the alarm, and returns whether or not it is on
  def toggle
    update(:is_on => !self.is_on)
    self.is_on
  end

  ## Returns true if it's time for the alarm to sound
  def should_sound?
    now = DateTime.now
    return false unless after_start_date?(now)
    return false unless has_weekly_repeat(wday_to_symbol(now.wday))
    return false unless now.hour == start_date.hour
    return false unless now.min == start_date.min
    true
  end

  private

  def validate_day_of_week(day)
    [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday].include?(day)
  end

  def wday_to_symbol(day)
    case day
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
        raise RuntimeError, 'Day requested that does not exist! This code should never run.'
    end
  end

  def after_start_date?(date)
    return true if date.year >= start_date.year
    return true if date.month >= start_date.month
    return true if date.yday >= start_date.yday
    false
  end
end