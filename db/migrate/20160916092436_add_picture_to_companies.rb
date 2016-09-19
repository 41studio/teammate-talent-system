class AddPictureToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :photo_company, :string
  end
end
