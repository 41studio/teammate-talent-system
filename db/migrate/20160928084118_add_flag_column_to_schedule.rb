class AddFlagColumnToSchedule < ActiveRecord::Migration
  def change
    add_column :schedules, :notify_applicant_flag, :string, null: false, default: "false"
  end
end
