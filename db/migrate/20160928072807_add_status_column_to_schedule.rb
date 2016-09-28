class AddStatusColumnToSchedule < ActiveRecord::Migration
  def change
    add_column :schedules, :status, :string, null: false, default: "false"
  end
end
