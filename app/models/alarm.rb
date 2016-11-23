require 'data_mapper'
require 'dm-types'

class Alarm
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :start_date, DateTime, :required => true
  property :repeat, Json, :default => []
  property :is_on, Boolean, :default => true

  ## Add a day of the week that this alarm should be repeated
  def add_weekly_repeat(day_of_week)
    return false unless validate_day_of_week(day_of_week)
    self.repeat.push(day_of_week) unless self.repeat.include?(day_of_week)
    save
    true
  end

  ## True if the day of the week passed is included as a day to repeat this alarm
  def has_weekly_repeat(day_of_week)
    return false unless validate_day_of_week(day_of_week)
    save
    self.repeat.include?(day_of_week.to_s)
  end

  ## Removes the day of week passed
  def remove_weekly_repeat(day_of_week)
    return false unless validate_day_of_week(day_of_week)
    self.repeat.delete(day_of_week.to_s)
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
    # TODO: This
  end

  private

  def validate_day_of_week(day)
    [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday].include?(day)
  end
end