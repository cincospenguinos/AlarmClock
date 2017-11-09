require 'sinatra'
require 'json'

require_relative '../lib/alarm_clock'
require_relative '../lib/alarm_migration'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: '.alarm_clock.db'
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
  # TODO: This
  send_response(false, {}, '')
end

## Add an alarm
post '/alarm' do
  repetitions = {}

  

  alarm = Alarm.new(name: params['name'], alarm_time: params['time'], repetitions: {}.to_json)
  send_response(false, {}, 'Not yet implemented')
end

## Toggle the alarm's repetitions
put '/alarm' do
    # TODO: This
end

## Remove an alarm
delete '/alarm' do
  # TODO: This
end

## Toggle an alarm's state
put '/toggle' do
  # TODO: This
end
