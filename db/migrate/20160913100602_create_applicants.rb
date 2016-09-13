class CreateApplicants < ActiveRecord::Migration
  def change
    create_table :applicants do |t|
      t.string :name,             null: false, default: ""
      t.string :gender,           null: false, default: ""
      t.date :date_birth,         null: false
      t.string :email,            null: false, default: ""
      t.string :headline,         null: false, default: ""
      t.string :phone,            null: false, default: ""
      t.string :address,          null: false, default: ""
      t.string :photo,            null: false, default: ""
      t.string :name_school,      null: false, default: ""
      t.string :state_study,      null: false, default: ""
      t.string :degree,           null: false, default: ""
      t.string :company_name,     null: false, default: ""
      t.string :industry,         null: false, default: ""
      t.string :title,            null: false, default: ""
      t.string :summary,          null: false, default: ""
      t.string :resume,           null: false, default: ""
      t.string :status,           null: false, default: ""

      t.timestamps null: false
    end
  end
end
