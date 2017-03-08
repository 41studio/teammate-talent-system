class AddUserIdToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :user_id, :integer, index: true, after: :job_search_keyword
    add_foreign_key :jobs, :users, column: :user_id
  end
end
