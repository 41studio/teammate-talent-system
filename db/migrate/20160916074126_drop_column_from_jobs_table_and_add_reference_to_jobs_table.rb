class DropColumnFromJobsTableAndAddReferenceToJobsTable < ActiveRecord::Migration
  def change
  	remove_column :jobs, :aplicant_experience
  	remove_column :jobs, :aplicant_function
  	remove_column :jobs, :aplicant_employment_type
  	remove_column :jobs, :aplicant_industry
  	remove_column :jobs, :aplicant_education

  	add_reference :jobs, :education_list, index: true, foreign_key: true
  	add_reference :jobs, :employment_type_list, index: true, foreign_key: true
  	add_reference :jobs, :experience_list, index: true, foreign_key: true
  	add_reference :jobs, :function_list, index: true, foreign_key: true
  	add_reference :jobs, :industry_list, index: true, foreign_key: true
  end
end
