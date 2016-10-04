class RemoveCommentReference < ActiveRecord::Migration
  def change
  	remove_reference :comments, :applicant, index: true, foreign_key: true
    remove_reference :comments, :user, index: true, foreign_key: true
  end
end
