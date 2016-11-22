require 'data_mapper'
require 'dm-types'

class Alarm
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :time, Time, :required => true
  property :start_date, Date, :required => true
  property :repeat, Json, :default => []
  property :is_on, Boolean, :default => true

  def add_weekly_repeat(day_of_week)
    return false unless validate_day_of_week(day_of_week)
    self.repeat.push(day_of_week) unless self.repeat.include?(day_of_week)
    save
    true
  end

  def has_weekly_repeat(day_of_week)
    return false unless validate_day_of_week(day_of_week)
    save
    self.repeat.include?(day_of_week.to_s)
  end

  def remove_weekly_repeat(day_of_week)
    return false unless validate_day_of_week(day_of_week)
    self.repeat.delete(day_of_week.to_s)
    save
  end

  ## Toggles the alarm, and returns whether or not it is on
  def toggle
    update(:is_on => !self.is_on)
    self.is_on
  end

  private

  def validate_day_of_week(day)
    [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday].include?(day)
  end
end