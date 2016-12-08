class DropRpushTables < ActiveRecord::Migration
  def up
    drop_table :rpush_apps
    drop_table :rpush_feedback
    drop_table :rpush_notifications
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
