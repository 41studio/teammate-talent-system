class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :company_name
      t.string :company_website
      t.string :company_email
      t.string :company_phone
      t.string :industry

      t.timestamps null: false
    end
  end
end
