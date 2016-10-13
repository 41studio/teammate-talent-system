module API
  module V1
    class Applicants < Grape::API
      version 'v1'
      format :json
      before { authenticate! }

      helpers do
        def applicant_params
          applicant_param = ActionController::Parameters.new(params).require(:applicant).permit(:name, :gender, :date_birth, :email, :headline, :phone, :address, photo: [:filename, :type, :name, :tempfile, :head], resume: [:filename, :type, :name, :tempfile, :head], educations_attributes: [:name_school, :field_study, :degree], experiences_attributes: [:name_company, :industry, :title, :summary])
          applicant_param["photo"] = ActionDispatch::Http::UploadedFile.new(params.applicants.photo) if params.applicants.photo.present? 
          applicant_param["resume"] = ActionDispatch::Http::UploadedFile.new(params.applicants.resume) if params.applicants.resume.present?
          applicant_param
        end

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

        desc "Edit Status", {
          :notes => <<-NOTE
          Edit Status applicant, for applicant edit status form (edit)
          -------------------------------------------------------------
          NOTE
        }
        params do
          use :applicant_id
        end
        get ':id/edit_status' do
          present Applicant::STATUSES, root: 'applicant_statuses'
          present :applicant, applicant, with: API::V1::Entities::Applicant, only: [:status]
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
              comments = Comment.build_from(applicant, current_user.id, comments_params)
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





