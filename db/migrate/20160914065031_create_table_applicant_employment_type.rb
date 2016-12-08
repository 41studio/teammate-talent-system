class CreateTableApplicantEmploymentType < ActiveRecord::Migration
  def change
    create_table :applicant_employment_types do |t|
    	t.string :employment_type
    end
  end
end
