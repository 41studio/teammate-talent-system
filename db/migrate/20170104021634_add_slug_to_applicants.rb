class AddSlugToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :slug, :string
    add_index :applicants, :slug
  end
end
