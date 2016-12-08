class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.datetime :date,           		null: false
      t.string :description,            null: false, default: "Interview Date"

      t.timestamps null: false
    end
  end
end
