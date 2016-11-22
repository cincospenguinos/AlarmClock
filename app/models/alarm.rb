require 'data_mapper'

class Alarm
  include DataMapper::Resource

  property :id, Serial
  property :time, Time, :required => true
  property :start_date, Date, :required => true
  property :repeat, JSON, :default => []
  property :on, Boolean, :default => false

  def add_weekly_repeat(day_of_week)
    return false unless validate_day_of_week(day_of_week)
    self.repeat.push(day_of_week) unless self.repeat.include?(day_of_week)
    save
    true
  end

  ## Toggles the alarm, and returns whether or not it is on
  def toggle
    update(:on => !self.on)
    save
    self.on
  end

  ## Deletes the alarm given the id. Returns true if the alarm
  ## was destroyed, or false if it does not exist
  def self.delete_alarm(id)
    alarm = Alarm.get(:id => id)
    if alarm
      alarm.destroy
      true
    else
      false
    end
  end

  private

  def validate_day_of_week(day)
    [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday].include?(day)
  end
end