require 'rspec'
require 'dm-mysql-adapter'

require_relative '../app/models/alarm'

describe 'Alarm' do

  before(:all) do
    # DataMapper::Logger.new($stdout, :debug)
    DataMapper.setup(:default, 'mysql://alarm:some_pass@localhost/AlarmClock')
    DataMapper::Model.raise_on_save_failure = true
    DataMapper.finalize
    DataMapper.auto_migrate!
  end

  after(:all) do
    Alarm.destroy!
  end

  it 'should be creatable' do
    alarm = Alarm.create(:name => 'Some alarm', :time => Time.new, :start_date => Date.new(2001, 2, 3))
    alarm = Alarm.first(:id => alarm.id)
    expect(alarm).to be_truthy
    expect(alarm.name).to eq('Some alarm')
  end

  it 'should be destroyable' do
    alarm_id = Alarm.create(:name => 'Some alarm', :time => Time.new, :start_date => Date.new(2016, 12, 12)).id
    Alarm.first(:id => alarm_id).destroy
    expect(Alarm.first(:id => alarm_id)).to be_falsey
  end

  it 'should able to be toggled' do
    alarm = Alarm.create(:name => 'Some alarm', :time => Time.new, :start_date => Date.new(2016, 12, 12))
    alarm.toggle
    expect(alarm.is_on).to be_falsey
    expect(Alarm.first(:id => alarm.id).is_on).to be_falsey
  end

  it 'should take repeatable days' do
    alarm = Alarm.create(:name => 'Some alarm', :time => Time.new, :start_date => Date.new(2016, 12, 12))
    alarm.add_weekly_repeat(:sunday)
    expect(alarm.repeat).to include(:sunday)
    expect(Alarm.first(:id => alarm.id).has_weekly_repeat(:sunday)).to be_truthy
  end

  it 'should remove repeatabled days on request' do
    alarm = Alarm.create(:name => 'Some alarm', :time => Time.new, :start_date => Date.new(2016, 12, 12))
    alarm.add_weekly_repeat(:sunday)
    expect(alarm.repeat).to include(:sunday)
    expect(Alarm.first(:id => alarm.id).has_weekly_repeat(:sunday)).to be_truthy

    alarm.remove_weekly_repeat(:sunday)
    expect(alarm.has_weekly_repeat(:sunday)).to be_falsey
  end
end