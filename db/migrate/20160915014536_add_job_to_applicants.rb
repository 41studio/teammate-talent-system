class AddJobToApplicants < ActiveRecord::Migration
  def change
    add_reference :applicants, :job, index: true, foreign_key: true
  end
end
