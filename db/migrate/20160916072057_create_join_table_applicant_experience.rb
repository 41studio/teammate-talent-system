class CreateJoinTableApplicantExperience < ActiveRecord::Migration
  def change
    create_join_table :applicants, :experiences do |t|
       t.index [:applicant_id, :experience_id]
       t.index [:experience_id, :applicant_id]
    end
  end
end
