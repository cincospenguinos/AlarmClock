require 'rack/test'
require 'rspec'
require 'json'

require_relative '../lib/alarm_clock'

# TODO: Finish these

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app/alarm_app', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure { |c| c.include RSpecMixin }

describe 'Alarm Clock web app' do

  alarm = nil

  before(:all) do
    config = YAML.load_file('alarm_config.yml')['test']

    DataMapper.setup(:default, "#{config['adapter']}://#{config['username']}:#{config['password']}@#{config['location']}/#{config['schema']}")
    DataMapper.finalize
    DataMapper.auto_upgrade!

    alarm = AlarmClock.create(:name => 'Some alarm', :start_date => DateTime.now)
  end

  after(:all) do
    AlarmClock.destroy!
  end

  it 'should show the homepage' do
    get '/'
    expect(last_response).to be_ok
  end

  it 'should give me all saved alarms' do
    get '/alarms'

    resp = JSON.parse(last_response.body)

    expect(resp['data']['alarms'].size).to eq(1)
    expect(resp['data']['alarms'][0]['id']).to eq(alarm.id)
  end

  it 'should have a new alarm be created given the proper parameters' do

  end

  it 'should not save an alarm given incorrect parameters' do

  end
end