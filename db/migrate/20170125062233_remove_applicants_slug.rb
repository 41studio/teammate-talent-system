class RemoveApplicantsSlug < ActiveRecord::Migration
  def change
    remove_column :applicants, :slug, :string
    remove_index :applicants, :slug
  end
end
