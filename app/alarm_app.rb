require 'sinatra/base'

class AlarmApp < Sinatra::Base
  get '/' do
    erb :index
  end
end