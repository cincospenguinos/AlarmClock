# alarm_migration.rb

class AlarmMigration < ActiveRecord::Migration
  def up
    create_table :alarms do |t|
      t.string :name, :null => false
      t.time :alarm_time, :null => false
      t.string :alarm_days, :null => false
      t.boolean :enabled, default: false
 
      t.timestamps(null: false)
    end
  end
 
  def down
    drop_table :alarms
  end
end