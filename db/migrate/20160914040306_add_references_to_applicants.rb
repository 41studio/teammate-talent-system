class AddReferencesToApplicants < ActiveRecord::Migration
  def change
    add_reference :applicants, :experience, index: true, foreign_key: true
    add_reference :applicants, :education, index: true, foreign_key: true
  end
end
