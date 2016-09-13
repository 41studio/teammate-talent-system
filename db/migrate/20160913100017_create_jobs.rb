class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :job_title,                   null: false, default: ""
      t.string :departement,                 null: false, default: ""
      t.string :job_code,                    null: false, default: ""
      t.string :country,                     null: false, default: ""
      t.string :state,                       null: false, default: ""
      t.string :city,                        null: false, default: ""
      t.string :zip_code,                    null: false, default: ""
      t.integer :min_salary,                 null: false, default: "0"
      t.integer :max_salary,                 null: false, default: "0"
      t.string :curency,                     null: false, default: ""
      t.text :job_description,               null: false
      t.text :job_requirement,               null: false
      t.text :benefits,                      null: false
      t.string :aplicant_experience,         null: false, default: ""
      t.string :aplicant_function,           null: false, default: ""
      t.string :aplicant_employment_type,    null: false, default: ""
      t.string :aplicant_industry,           null: false, default: ""
      t.string :aplicant_education,          null: false, default: ""
      t.string :job_search_keyword,          null: false, default: ""

      t.timestamps null: false
    end
  end
end
