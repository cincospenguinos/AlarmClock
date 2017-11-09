require 'sinatra'
require 'json'
require 'byebug'

require_relative '../lib/alarm'
require_relative '../lib/alarm_migration'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: '.alarms.db'
)

if !ActiveRecord::Base.connection.table_exists?(:alarms)
  AlarmMigration.new.up
end

helpers do
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
  send_response(true, { alarms: Alarm.all }, '')
end

## Add an alarm
post '/alarm' do
  days = []

  params['days'].each do |day|
    days << day
  end

  time = Time.parse(params['time'])

  if days.size == 0
    send_response(false, {}, 'Must have multiple days')
  else
    alarm = Alarm.new(name: params['name'], alarm_time: time, days: days.to_json)

    if alarm.valid?
      alarm.save!
      send_response(true, { alarms: Alarm.all }, '')
    else
      send_response(false, {}, 'Alarm not valid!')
    end
  end
end

## Toggle the alarm's days
put '/alarm' do
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

    puts "---> #{alarm.inspect}"
    send_response(true, {}, '')
  end
end

## Remove an alarm
delete '/alarm' do
  # TODO: This
  send_response(false, {}, 'Not implemented')
end

## Toggle an alarm's state
put '/toggle' do
  # TODO: This
  send_response(false, {}, 'Not implemented')
end
