require 'sinatra/base'
require 'json'

require_relative 'alarm'

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

  ## Shows the index page
  get '/' do
    erb :index
  end

  # Returns all the alarms
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

  ## Toggle the alarm's repetitions
  put '/alarm' do
    if params['day']
      begin
        alarm = Alarm.first(:id => params['id'].to_i)

        if alarm
          if alarm.has_weekly_repeat(params['day'].downcase.to_sym)
            alarm.remove_weekly_repeat(params['day'].downcase.to_sym)
          else
            alarm.add_weekly_repeat(params['day'].downcase.to_sym)
          end

          send_response(true, {}, 'Alarm modified.')
        else
          send_response(false, {}, 'No alarm matching the provided ID was found.')
        end
      rescue
        send_response(false, {}, 'The ID provided was not an integer')
      end
    else
      send_response(false, {}, 'There was no day provided.')
    end
  end

  # Remove an alarm
  delete '/alarm' do
    begin
      alarm = Alarm.first(:id => params['id'].to_i)

      if alarm
        alarm.destroy
        send_response(true, {}, '')
      else
        send_response(false, {}, 'There is no alarm matching that ID')
      end
    rescue
      send_response(false, {}, 'The ID provided was not an integer')
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