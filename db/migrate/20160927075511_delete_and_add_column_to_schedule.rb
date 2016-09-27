class DeleteAndAddColumnToSchedule < ActiveRecord::Migration
  def change
  	remove_column :schedules, :description
  	add_column :schedules, :category, :string, null: false 
  end
end
