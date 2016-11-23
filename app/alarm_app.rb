require 'sinatra/base'
require 'json'

require_relative 'models/alarm'

class AlarmApp < Sinatra::Base

  helpers do
    def send_response(successful, data, message)
      resp = {}
      resp[:successful] = successful
      resp[:data] = data
      resp[:message] = message
      resp.to_json
    end
  end

  get '/' do
    erb :index
  end

  # TODO Returns all the alarms
  get '/alarms' do
    send_response(true, {:alarms => Alarm.all}, '')
  end

  ## Add an alarm
  post '/alarm' do
    # TODO: Validation!
    date = DateTime.strptime("#{params['date']}T#{params['time']}", '%Y-%m-%dT%H:%M')
    alarm = Alarm.create(:name => params['name'], :start_date => date)

    params['repetitions'].each do |day|
      alarm.add_weekly_repeat(day.downcase.to_sym)
    end

    send_response(true, {}, '')
  end

  # Remove an alarm
  delete '/alarm' do
    alarm = nil

    begin
      alarm = Alarm.first(:id => params['id'].to_i)
    rescue
      send_response(false, {}, 'The ID provided was not an integer')
    end

    if alarm
      alarm.destroy
      send_response(true, {}, '')
    else
      send_response(false, {}, 'There is no alarm matching that ID')
    end
  end

  # Toggle an alarm's state
  put '/toggle' do
    alarm = nil

    begin
      alarm = Alarm.first(:id => params['id'].to_i)
      if alarm
        alarm.toggle
        send_response(true, {}, '')
      else
        puts "PARAMS ID: #{params['id'].to_i}"
        send_response(false, {}, 'There is no alarm matching that ID')
      end
    rescue
      send_response(false, {}, 'The ID provided was not an integer')
    end
  end
end