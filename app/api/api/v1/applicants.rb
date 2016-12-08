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
          applicant_param = ActionController::Parameters.new(params).require(:applicant).permit(:job_id, :name, :gender, :date_birth, :email, :headline, :phone, :address, photo: [:filename, :type, :name, :tempfile, :head], resume: [:filename, :type, :name, :tempfile, :head], educations_attributes: [:name_school, :field_study, :degree], experiences_attributes: [:name_company, :industry, :title, :summary])

          if params.applicant.educations_attributes.present?
            params.applicant.educations_attributes.each do |key, val|
              applicant_param["educations_attributes"]["#{key}"]  = params.applicant.educations_attributes[key]
            end
          end
          
          if params.applicant.experiences_attributes.present?
            params.applicant.experiences_attributes.each do |key, val|
              applicant_param["experiences_attributes"]["#{key}"] = params.applicant.experiences_attributes[key]
            end
          end

          applicant_param["photo"]  = ActionDispatch::Http::UploadedFile.new(params.applicant.photo) if params.applicant.photo.present? 
          applicant_param["resume"] = ActionDispatch::Http::UploadedFile.new(params.applicant.resume) if params.applicant.resume.present?
          applicant_param
        end

        def error_message
          error!({ status: :error, message: @applicant.errors.full_messages.first }) if @applicant.errors.any?
        end       
      end

      resource :applicants do
        before do
          unless request.path.include?("applicants/create")
            authenticate!
            set_applicant
            applicant_valid
          end
        end

        desc "Create Applicant" do
          detail ' : create process (save)'
          params API::V1::Entities::ApplicantEntity.documentation
          named 'applicants'
        end
        params do
          group :applicant, type: Hash do
            requires :job_id,     type: String, regexp: /^[0-9]/, desc: 'Job id',                                   allow_blank: false
            requires :name,       type: String, desc: 'Applicant name',                           allow_blank: false
            requires :gender,     type: String, values: { value: ['Male', 'Female'], message: 'not valid' }, 
                                                desc: 'Applicant gender',                         allow_blank: false
            requires :date_birth, type: Date,   desc: 'Applicant date birth',                     allow_blank: false
            requires :email,      type: String, regexp: /.+@.+/,  desc: 'Applicant email',        allow_blank: false
            requires :headline,   type: String, desc: 'Applicant headline',                       allow_blank: false
            requires :phone,      type: String, regexp: /^[0-9]/, desc: 'Applicant phone number', allow_blank: false
            requires :address,    type: String, desc: 'Applicant address',                        allow_blank: false
            group :educations_attributes, type: Hash do
              optional :"#{0}", type: Hash do
                optional :name_school, type: String, desc: 'School name'
                optional :field_study, type: String, desc: 'Field study'
                optional :degree,      type: String, desc: 'School degree'
              end
            end
            group :experiences_attributes, type: Hash do
              optional :"#{0}", type: Hash do
                optional :name_company, type: String, desc: 'Company Name '
                optional :industry,     type: String, desc: 'Company industry'
                optional :title,        type: String, desc: 'Experience title'
                optional :summary,      type: String, desc: 'Experience summary'
              end
            end
            requires :photo,  type: File, desc: "Applicant photo",  allow_blank: false
            requires :resume, type: File, desc: "Applicant resume", allow_blank: false
          end
        end
        post '/create' do
          job = Job.find(params.applicant.job_id)
          @applicant = job.applicants.new(applicant_params)
          @applicant.status = "applied"
          if @applicant.save!
            { status: "Applying success" }
          else
            error_message
          end
        end 

        desc "Applicant detail" do
          detail ' : show applicant by id'
          named 'applicants'
          headers token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :applicant_id       
        end
        get ":id/detail" do
          begin 
            present :user, current_user, with: API::V1::Entities::UserEntity, only: [:avatar]
            present :applicant, @applicant, with: API::V1::Entities::ApplicantEntity, except: [ { educations: [:id], experiences: [:id], comments:  [ user: [:id, :first_name, :last_name, :email, :joined_at, :token] ] }]
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
          end
        end

        desc "Edit Status" do
          detail ' : edit status form (edit)'
          named 'applicants'
          headers token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :applicant_id
        end
        get ':id/edit_status' do
          present Applicant::STATUSES, root: 'applicant_statuses'
          present :applicant, @applicant, with: API::V1::Entities::ApplicantEntity, only: [:status]
        end

        desc "Update Status Applicant" do
          detail ' : update applicant status process (update)'
          named 'applicants'
          headers token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :applicant_id
          requires :status, type: String, values: { value: Applicant.applicant_statuses, message: 'not valid' }, desc: "Applicant status"
        end
        put ':id/update_status/' do
          begin
            unless @applicant.status == Applicant::DISQUALIFIED
              if @applicant.update_attribute(:status, params[:status])
                { status: "Applicant status updated" }
              else
                error_message
              end
            else
              { status: "This applicant cannot do any changes" }
            end
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
          end
        end

        desc "Disqualified Applicant" do
          detail ' : update applicant status to disqualified process (update)'
          named 'applicants'
          headers token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :applicant_id
        end
        put ':id/disqualified/' do
          begin
            if @applicant.update_attribute(:status, Applicant::DISQUALIFIED)
              { status: "Applicant disqualified" }
            else
              error_message
            end
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
          end
        end

      end #end resource
    end
  end
end





