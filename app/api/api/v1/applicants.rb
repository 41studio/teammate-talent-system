module API
  module V1
    class Applicants < Grape::API
      version 'v1'
      format :json
      helpers Helpers

      helpers do
        params :applicant_id do
          requires :id, type: Integer, desc: "Applicant id" 
        end

        def applicant_params
          applicant_param = ActionController::Parameters.new(params).require(:applicants).permit(:job_id, :name, :gender, :date_birth, :email, :headline, :phone, :address, photo: [:filename, :type, :name, :tempfile, :head], resume: [:filename, :type, :name, :tempfile, :head], educations_attributes: [:name_school, :field_study, :degree], experiences_attributes: [:name_company, :industry, :title, :summary])

          if params.applicants.educations_attributes.present?
            params.applicants.educations_attributes.each do |key, val|
              applicant_param["educations_attributes"]["#{key}"] = params.applicants.educations_attributes[key]
            end
          end
          
          if params.applicants.experiences_attributes.present?
            params.applicants.experiences_attributes.each do |key, val|
              applicant_param["experiences_attributes"]["#{key}"] = params.applicants.experiences_attributes[key]
            end
          end

          applicant_param["photo"] = ActionDispatch::Http::UploadedFile.new(params.applicants.photo) if params.applicants.photo.present? 
          applicant_param["resume"] = ActionDispatch::Http::UploadedFile.new(params.applicants.resume) if params.applicants.resume.present?
          applicant_param
        end

        def applicant
          Applicant.find(params[:id])
        end
        
        def schedule_params
          ActionController::Parameters.new(params).require(:schedule).permit(:start_date, :end_date, :category)
        end

        def comment_params
          ActionController::Parameters.new(params).require(:comment).permit(:body)
        end   

        def error_message
          error!({ status: :error, message: applicant.errors.full_messages.first }) if applicant.errors.any?
        end       
      end


      resource :applicants do
        before do
          unless request.path.include?("applicants/create")
            authenticate!
            applicant_valid
          end
        end

        desc "Create Applicant", {
          :notes => <<-NOTE
          Create Applicant, save process (save)
          -------------------------------------
          NOTE
        }
        params do
          requires :applicants, type: Hash do
            requires :job_id, type: String, allow_blank: false
            requires :name, type: String, allow_blank: false
            requires :gender, type: String, allow_blank: false
            requires :date_birth, type: String, allow_blank: false
            requires :email, type: String, allow_blank: false
            requires :headline, type: String, allow_blank: false
            requires :phone, type: String, allow_blank: false
            requires :address, type: String, allow_blank: false
            optional :educations_attributes, type: Hash do
              optional :"#{0}", type: Hash do
                optional :name_school, type: String
                optional :field_study, type: String
                optional :degree, type: String
              end
            end
            optional :experiences_attributes, type: Hash do
              optional :"#{0}" , type: Hash do
                optional :name_company, type: String
                optional :industry, type: String
                optional :title, type: String
                optional :summary, type: String
              end
            end
            requires :photo, type: File, desc: "Applicant photo", allow_blank: false
            requires :resume, type: File, desc: "Applicant resume", allow_blank: false
          end
        end
        post '/create' do
          job = Job.find(params.applicants.job_id)
          applicant = job.applicants.new(applicant_params)
          applicant.status = "applied"
          if applicant.save!
            { status: :success }
          else
            error_message
          end
        end 

        desc "Applicant By  Id", {
          :notes => <<-NOTE
          Get Applicant  By Id
          ---------------------
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
          ----------------------- 
          NOTE
        }
        params do
          use :applicant_id
          requires :status        ,type: String, values: { value: Applicant::STATUSES.map{|key, val| key.to_s}, message: 'not valid' }, desc: "Applicant status"
        end
        put ':id/update_status/' do
          begin
            unless applicant.status == Applicant::DISQUALIFIED
              if applicant.update_attribute(:status, params[:status])
                { status: :success }
              else
                error!({ status: :error, message: applicant.errors.full_messages.first }) if applicant.errors.any?
              end
            else
              { status: :this_applicant_cannot_do_any_changes }
            end
       
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
          end
        end

        desc "Disqualified Applicant", {
          :notes => <<-NOTE
          Update status to disqualified
          -----------------------------
          NOTE
        }
        params do
          use :applicant_id
        end
        put ':id/disqualified/' do
          begin
            if applicant.update_attribute(:status, Applicant::DISQUALIFIED)
              { status: :applicant_disqualified }
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
          requires :comment, type: Hash do
            requires :body, type: String, allow_blank: false
          end
        end        
        post ':id/comment/new' do
          begin
            if applicant
              comments = Comment.build_from(applicant, current_user.id, comment_params)
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





