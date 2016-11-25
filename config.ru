require 'data_mapper'
require 'dm-migrations'

require_relative 'app/alarm_app'

# Setup datamapper bullshilogna
# DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'mysql://alarm:some_pass@localhost/AlarmClock')
DataMapper.finalize
DataMapper.auto_upgrade!

run Sinatra::Application