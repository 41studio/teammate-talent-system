class AddUserToSchedules < ActiveRecord::Migration
  def change
    add_reference :schedules, :assignee, references: :users, index: true
    add_foreign_key :schedules, :users, column: :assignee_id 
    
  end
end