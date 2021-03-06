require 'rspec'
require 'dm-mysql-adapter'

require_relative '../lib/alarm_clock'

describe 'Alarm' do

  def get_today_symbol
    case DateTime.now.wday
      when 0
        :sunday
      when 1
        :monday
      when 2
        :tuesday
      when 3
        :wednesday
      when 4
        :thursday
      when 5
        :friday
      when 6
        :saturday
      else
        :nothing
    end
  end

  before(:all) do
    # DataMapper::Logger.new($stdout, :debug)
    DataMapper.setup(:default, 'mysql://alarm:some_pass@localhost/AlarmClock')
    DataMapper::Model.raise_on_save_failure = true
    DataMapper.finalize
    DataMapper.auto_migrate!
  end

  after(:all) do
    AlarmClock.destroy!
  end

  it 'should be creatable' do
    alarm = AlarmClock.create(:name => 'Some alarm', :start_date => DateTime.now)
    alarm = AlarmClock.first(:id => alarm.id)
    expect(alarm).to be_truthy
    expect(alarm.name).to eq('Some alarm')
  end

  it 'should be destroyable' do
    alarm_id = AlarmClock.create(:name => 'Some alarm', :start_date => DateTime.now).id
    AlarmClock.first(:id => alarm_id).destroy
    expect(AlarmClock.first(:id => alarm_id)).to be_falsey
  end

  it 'should able to be toggled' do
    alarm = AlarmClock.create(:name => 'Some alarm', :start_date => DateTime.now)
    alarm.toggle
    expect(alarm.is_on).to be_falsey
    expect(AlarmClock.first(:id => alarm.id).is_on).to be_falsey
  end

  it 'should take repeatable days' do
    alarm = AlarmClock.create(:name => 'Some alarm', :start_date => DateTime.now)
    alarm.add_weekly_repeat(:sunday)
    expect(alarm.repeat).to include(:sunday)
  end

  it 'should remove repeatable days on request' do
    alarm = AlarmClock.create(:name => 'Some alarm', :start_date => DateTime.now)
    alarm.add_weekly_repeat(:sunday)
    expect(alarm.repeat).to include(:sunday)

    alarm.remove_weekly_repeat(:sunday)
    expect(alarm.has_weekly_repeat(:sunday)).to be_falsey
  end

  it 'should properly indicate when it is time for the alarm to sound' do
    alarm = AlarmClock.create(:name => 'Some alarm', :start_date => DateTime.now)
    alarm.add_weekly_repeat(get_today_symbol)
    expect(alarm.has_weekly_repeat(get_today_symbol)).to be_truthy
    expect(alarm.should_sound?).to be_truthy
  end
end