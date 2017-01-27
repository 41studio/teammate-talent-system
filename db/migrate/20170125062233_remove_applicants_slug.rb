class RemoveApplicantsSlug < ActiveRecord::Migration
  def change
    remove_column :applicants, :slug, :string
  end
end
