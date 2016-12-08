class CreateTableApplicantEducation < ActiveRecord::Migration
  def change
    create_table :applicant_educations do |t|
    	t.string :education
    end
  end
end
