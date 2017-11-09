# alarm_migration.rb
require 'active_record'

class AlarmMigration < ActiveRecord::Migration[5.1]
  def up
    create_table :alarms do |t|
      t.string :name, :null => false
      t.time :alarm_time, :null => false
      t.string :days, :null => false
      t.boolean :enabled, default: true
 
      t.timestamps(null: false)
    end
  end
 
  def down
    drop_table :alarms
  end
end