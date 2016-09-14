class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.string :name_school
      t.string :field_study
      t.string :degree

      t.timestamps null: false
    end
  end
end
