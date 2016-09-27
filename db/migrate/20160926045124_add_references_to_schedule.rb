class AddReferencesToSchedule < ActiveRecord::Migration
  def change
    add_reference :schedules, :applicant, index: true, foreign_key: true
  end
end
