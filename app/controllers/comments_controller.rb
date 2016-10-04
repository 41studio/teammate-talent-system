class CommentsController < ApplicationController
	before_action :authenticate_user!
	
	def create
		@applicant = Applicant.find(params[:applicant_id])
		@comment = Comment.build_from(@applicant, current_user.id, params[:comment][:body])
    respond_to do |format|
    	if @comment.save
    		format.html { redirect_to company_job_applicant_path(params[:company_id], params[:job_id], params[:applicant_id]), notice: "commented" }
    	else
    		format.html { redirect_to company_job_applicant_path(params[:company_id], params[:job_id], params[:applicant_id]) }
    	end
    end
	end

	def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type, :comment_id)
  end

  # def commentable_type
  #   comment_params[:commentable_type]
  # end

  # def commentable_id
  #   comment_params[:commentable_id]
  # end

  # def comment_id
  #   comment_params[:comment_id]
  # end

  # def body
  #   comment_params[:body]
  # end

  def make_child_comment
    return "" if comment_id.blank?
    parent_comment = Comment.find comment_id
    @comment.move_to_child_of(parent_comment)
  end
end
