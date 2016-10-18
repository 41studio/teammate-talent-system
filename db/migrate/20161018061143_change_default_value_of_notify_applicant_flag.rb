class ChangeDefaultValueOfNotifyApplicantFlag < ActiveRecord::Migration
  def up
  	change_column :schedules, :notify_applicant_flag, :boolean, null: false, default: false
  end

  def down
    change_column :schedules, :notify_applicant_flag, :string, null: false, default: "false"
  end
end
