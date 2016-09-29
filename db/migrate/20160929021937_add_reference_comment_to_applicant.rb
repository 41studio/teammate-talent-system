class AddReferenceCommentToApplicant < ActiveRecord::Migration
  def change
  	add_reference :comments, :applicant, index: true, foreign_key: true
  end
end
