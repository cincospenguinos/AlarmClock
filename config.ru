require 'yaml'
require 'data_mapper'
require 'dm-migrations'

require_relative 'app/alarm_app'

# Configure DataMapper
begin
  config = YAML.load_file('alarm_config.yml')

  DataMapper.setup(:default, "#{config['adapter']}://#{config['username']}:#{config['password']}@#{config['location']}/#{config['schema']}")
  DataMapper.finalize
  DataMapper.auto_upgrade!
rescue
  puts 'There is an issue with the config file. Ensure that alarm_config is setup properly.'
  exit 1
end

run Sinatra::Application