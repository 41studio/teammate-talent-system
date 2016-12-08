class RemoveExperienceAndEducationColumn < ActiveRecord::Migration
  def change
  	remove_column :applicants, :name_school
  	remove_column :applicants, :state_study
  	remove_column :applicants, :degree
  	remove_column :applicants, :company_name
  	remove_column :applicants, :industry
  	remove_column :applicants, :title
  	remove_column :applicants, :summary
  end
end
