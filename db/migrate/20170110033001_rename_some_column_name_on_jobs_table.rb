class RenameSomeColumnNameOnJobsTable < ActiveRecord::Migration
  def change
    rename_column :jobs, :job_title, :title
    rename_column :jobs, :job_code, :code
    rename_column :jobs, :job_description, :description
    rename_column :jobs, :job_requirement, :requirement
    rename_column :jobs, :job_search_keyword, :search_keyword
  end
end
