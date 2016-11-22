require 'data_mapper'

class Alarm
  include DataMapper::Resource

  property :id, Serial
  property :time, Time, :required => true
  property :on, Boolean, :default => false

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
end