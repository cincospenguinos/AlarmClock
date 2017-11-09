require 'sinatra'
require 'json'
require 'yaml'

require_relative '../lib/alarm'
require_relative '../lib/alarm_migration'

db_config = YAML::load(File.open('db_config.yml'))

ActiveRecord::Base.establish_connection(db_config)

if !ActiveRecord::Base.connection.table_exists?(:alarms)
  AlarmMigration.new.up
end

helpers do
  def all_alarms
    alarms = nil

    ActiveRecord::Base.connection_pool.with_connection do
      alarms = Alarm.all
      alarms.each do |a|
        a.alarm_time = a.alarm_time.localtime
      end
    end

    alarms
  end

  def send_response(successful, data, message)
    resp = {}
    resp[:successful] = successful
    resp[:data] = data
    resp[:message] = message
    resp.to_json
  end
end

## Shows the index page
get '/' do
  erb :index
end

## Returns all the alarms
get '/alarms' do
  send_response(true, { alarms: all_alarms }, '')
end

## Add an alarm
post '/alarm' do
  days = []

  params['days'].each do |day|
    days << day
  end

  now = Time.now
  time = Time.parse(params['time'])
  time = Time.mktime(now.year, now.month, now.day, time.hour, time.min)

  ActiveRecord::Base.connection_pool.with_connection do
    alarm = Alarm.new(name: params['name'], alarm_time: time.localtime, days: days.to_json)

    if alarm.valid?
      alarm.save!
      send_response(true, { alarms: all_alarms }, '')
    else
      send_response(false, {}, 'Alarm not valid!')
    end
  end
end

## Toggle the alarm's days
put '/alarm' do
  ActiveRecord::Base.connection_pool.with_connection do
    alarm = Alarm.find(params['id'])

    if alarm.nil?
      send_response(false, {}, 'Could not find alarm!')
    else
      days = JSON.parse(alarm.days)

      if days.include?(params['day'])
        days.delete(params['day'])
      else
        days << params['day']
      end

      alarm.days = days.to_json
      alarm.save!

      send_response(true, {}, '')
    end
  end
end

## Remove an alarm
delete '/alarm' do
  # TODO: This
  id = params['id']
  id = id.to_i if id.is_a?(String)

  ActiveRecord::Base.connection_pool.with_connection do
    Alarm.destroy(id)
  end

  send_response(true, {}, 'Deleted.')
end

## Toggle an alarm's state
put '/toggle' do
  id = params['id']
  id = id.to_i if id.is_a?(String)

  ActiveRecord::Base.connection_pool.with_connection do
    alarm = Alarm.find(id)
    alarm.enabled = !alarm.enabled
    alarm.save!
  end

  send_response(true, {}, 'Toggled.')
end
