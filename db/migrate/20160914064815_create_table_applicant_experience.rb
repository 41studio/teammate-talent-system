class CreateTableApplicantExperience < ActiveRecord::Migration
  def change
    create_table :applicant_experiences do |t|
    	t.string :experience
    end
  end
end
