module API
  module V1
    class Comments < Grape::API
      version 'v1'
      format :json
      helpers Helpers

      helpers do
        params :applicant_id do
          requires :applicant_id, type: Integer, desc: "Applicant id" 
        end

        def comment_params
          ActionController::Parameters.new(params).permit(:body)
        end   

        def set_applicant
          @applicant = Applicant.find(params[:applicant_id])
        end

        def error_message
            error!({ status: :error, message: @comment.errors.full_messages.first }) if @comment.errors.any?
        end       
      end

      resource :applicants do
        segment '/:applicant_id' do
          resource :comments do
  	        before do
  	        	authenticate!
  	        	set_applicant
  	        	applicant_valid
  	        end

            desc "Comments List Applicant" do
              detail ' : applicant comment threads (show)'
              named 'comments'
              headers token: {
                      description: 'Validates user identity by token',
                      required: true
                    }
            end
            params do
              use :applicant_id
            end        
            get '/all' do
              begin
                present :comments, @applicant.comment_threads, with: API::V1::Entities::CommentEntity, except: [{ user: [:id, :first_name, :last_name, :email, :joined_at, :token] }]
              rescue ActiveRecord::RecordNotFound
                record_not_found_message
              end 
            end

            desc "Comment Applicant" do
              detail ' : applicant commented by user (create comment)'
              named 'comments'
              headers token: {
                      description: 'Validates user identity by token',
                      required: true
                    }
            end
            params do
              use :applicant_id
              requires :body,         type: String,  desc: 'Comment body', allow_blank: false
            end        
            post '/create' do
              begin
                @comment = Comment.build_from(@applicant, current_user.id, comment_params[:body])
                if @comment.save!
                  { status: "Comment sent" }
                else
                	error_message
                end
              rescue ActiveRecord::RecordNotFound
                record_not_found_message
              end 
            end

          end
        end #end segement 
      end #end resource
    end
  end
end
