require 'sinatra/base'
require 'json'

require_relative 'models/alarm'

class AlarmApp < Sinatra::Base
  get '/' do
    erb :index
  end

  # TODO Returns all the alarms
  get '/alarms' do

  end

  # TODO Add an alarm
  post '/add' do

  end

  # TODO Remove an alarm
  post '/delete' do

  end

  # TODO Modify an alarm
  put '/modify' do

  end
end