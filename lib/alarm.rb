require 'active_record'

class Alarm < ActiveRecord::Base

	# TODO: Test this
	def should_alarm?
		now = Time.now
		alarm_time.min == now.min && alarm_time.hour == now.hour && weekdays_from_days.include?(now.wday)
	end

	private

	def weekdays_from_days
		weekdays = []

		JSON.parse(days).each do |d|
			case d
			when 'Sunday'
				weekdays << 0
			when 'Monday'
				weekdays << 1
			when 'Tuesday'
				weekdays << 2
			when 'Wednesday'
				weekdays << 3
			when 'Thursday'
				weekdays << 4
			when 'Friday'
				weekdays << 5
			when 'Saturday'
				weekdays << 6
		end

		weekdays
	end
end