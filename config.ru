require 'yaml'
require 'data_mapper'
require 'dm-migrations'

require_relative 'app/alarm_app'

begin
  config = YAML.load_file('alarm_config.yml')

  DataMapper.setup(:default, "#{config['adapter']}://#{config['username']}:#{config['password']}@#{config['location']}/#{config['schema']}")
  DataMapper.finalize
  DataMapper.auto_upgrade!
rescue
  puts 'The database or config file may not be setup properly. Ensure these things are in order.'
  exit 1
end

run Sinatra::Application