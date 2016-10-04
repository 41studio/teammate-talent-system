class RenameAndAddColumnToSchedules < ActiveRecord::Migration
  def self.up
  	rename_column :schedules, :date, :start_date
  	add_column :schedules, :end_date, :datetime, null: false
  end

  def self.down
  	rename_column :schedules, :start_date, :date
  	remove_column :schedules, :end_date
  end

end
