class ChangeNameOf5Tables < ActiveRecord::Migration
  def change
  	rename_table :applicant_educations, :education_lists
  	rename_table :applicant_employment_types, :employment_type_lists
  	rename_table :applicant_experiences, :experience_lists
  	rename_table :applicant_functions, :function_lists
  	rename_table :applicant_industries, :industry_lists
  end
end
