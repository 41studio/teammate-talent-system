class CreateTableApplicantFunction < ActiveRecord::Migration
  def change
    create_table :applicant_functions do |t|
    	t.string :function
    end
  end
end
