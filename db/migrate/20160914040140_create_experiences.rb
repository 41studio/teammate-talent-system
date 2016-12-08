class CreateExperiences < ActiveRecord::Migration
  def change
    create_table :experiences do |t|
      t.string :name_company
      t.string :industry
      t.string :title
      t.string :summary

      t.timestamps null: false
    end
  end
end
