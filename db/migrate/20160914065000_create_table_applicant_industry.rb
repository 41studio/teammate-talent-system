class CreateTableApplicantIndustry < ActiveRecord::Migration
  def change
    create_table :applicant_industries do |t|
    	t.string :industry
    end
  end
end
