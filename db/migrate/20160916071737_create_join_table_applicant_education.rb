class CreateJoinTableApplicantEducation < ActiveRecord::Migration
  def change
    create_join_table :applicants, :educations do |t|
       t.index [:applicant_id, :education_id]
       t.index [:education_id, :applicant_id]
    end
  end
end
