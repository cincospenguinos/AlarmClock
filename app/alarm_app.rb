require 'sinatra/base'

class AlarmApp < Sinatra::Base
  get '/' do
    'Hello, world!'
  end
end