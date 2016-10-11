module API
  module V1
    class Applicants < Grape::API
      version 'v1'
      format :json
      before { authenticate! }

      helpers do
        params :applicant_id do
          requires :id, type: Integer, desc: "Applicant id" 
        end

        def applicant
          Applicant.find(params[:id])
        end

        def comments_params
          ActionController::Parameters.new(params).require(:body)
        end   
      end

      resource :applicants do
        desc "Applicant By  Id", {
          :notes => <<-NOTE
          Get Applicant  By Id
          --------------------- comment nya belum
          NOTE
        }
        params do
          use :applicant_id       
        end
        get ":id/detail" do
          begin 
            present applicant, with: API::V1::Entities::Applicant
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
          end
        end

        desc "Update Status Applicant By Id", {
          :notes => <<-NOTE
          Update Applicant By Id
          ----------------------- send email notify status info
          NOTE
        }
        params do
          use :applicant_id
          requires :status        ,type: String, desc: "Applicant status"
        end
        put ':id/update_status/' do
          begin
            if applicant.update_attribute(:status, params[:status])
              { status: :success }
            else
              error!({ status: :error, message: applicant.errors.full_messages.first }) if applicant.errors.any?
            end
     
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
          end
        end

        desc "Comment Applicant", {
          :notes => <<-NOTE
          User Comment Applicant
          ----------------------
          NOTE
        }
        params do
          use :applicant_id      
        end        
        post ':id/comment/new' do
          begin
            if applicant
              comments = Comment.new(commentable_id: params[:id], user_id: current_user.id, body: comments_params, commentable_type: "Applicant")
              if comments.save!
                { status: :success }
              else
                error!({ status: :error, message: comments.errors.full_messages.first }) if comments.errors.any?
              end
            end

          rescue ActiveRecord::RecordNotFound
            record_not_found_message
          end 
        end 

      end #end resource
    end
  end
end





