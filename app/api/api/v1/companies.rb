module API
  module V1
    class Companies < Grape::API
      version 'v1' 
      format :json 
      helpers Helpers

      helpers do
        params :company do
          requires :company_name,    type: String, allow_blank: false
          requires :company_website, type: String, allow_blank: false
          requires :company_email,   type: String, regexp: /.+@.+/,  allow_blank: false
          requires :company_phone,   type: String, regexp: /^[0-9]/, allow_blank: false
          requires :industry,        type: String, allow_blank: false
        end

        def company_params
          company_param = ActionController::Parameters.new(params).require(:company).permit(:company_name, :company_website, :company_email, :company_phone, :industry, photo_company: [:filename, :type, :name, :tempfile, :head])
          company_param["photo_company"] = ActionDispatch::Http::UploadedFile.new(params.company.photo_company) if params.company.photo_company.present? 
          company_param
        end

        def invitation_params
          ActionController::Parameters.new(params).permit(:email)
        end

        def field_on_company_form
          industry_list = IndustryList.all
          present :industry_list, industry_list, with: API::V1::Entities::IndustryListEntity, only: [:industry]
        end     

        def field_on_report_filter_form

        end

        def set_company
          @company = current_user.company
        end

        def error_message
          error!({ status: :error, message: @company.errors.full_messages.first }) if @company.errors.any?
        end
      end      

      resource :companies do
        before do
          authenticate!
          set_company
        end

        desc "New Company", {
          :notes => <<-NOTE
          New Company, for Company form (new)
          ----------------------------------
          NOTE
        }
        get '/new' do
          field_on_company_form
        end

        desc "Create Company" do
          detail ' : create process (save)'
          params API::V1::Entities::CompanyEntity.documentation
          named 'companies'
          headers token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          requires :company, type: Hash do
            use :company
            requires :photo_company, type: File, allow_blank: false
          end
        end
        post '/create' do
          if @company
            { status: "You are belongs to one company" }
          else
            @company = Company.create(company_params)
            if @company.save!
              current_user.update_attribute(:company_id, @company.id)
              { status: "Company created" }
            else
              error_message
            end
          end
        end   

        desc "Company detail" do
          detail ' : show company'
          params API::V1::Entities::CompanyEntity.documentation
          named 'companies'
          headers token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        get '/detail' do
          begin
            @company.present? ? API::V1::Entities::CompanyEntity.represent(@company) : "Create company profile first"
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
           end
        end

        desc "Edit Company" do
          detail ' : edit company form (edit)'
          params API::V1::Entities::CompanyEntity.documentation
          named 'companies'
          headers token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        get '/edit' do
          begin
            field_on_company_form
            present :company, @company, with: API::V1::Entities::CompanyEntity
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
           end
        end

        desc "Update Company" do
          detail ' : update company process (update)'
          params API::V1::Entities::CompanyEntity.documentation
          named 'companies'
          headers token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          requires :company, type: Hash do
            use :company
            optional :photo_company, type: File
          end
        end
        put '/update' do
          if @company
            if @company.update(company_params)
              { status: "Company updated" }
            else
              error_message
            end
          else
            record_not_found_message
          end
        end 

        desc "Users in company" do
          detail ' : users list in company (show)'
          params API::V1::Entities::CompanyEntity.documentation
          named 'companies'
          headers token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :pagination
        end
        get '/users' do
          begin
            users = User.by_company_id(@company)
            present :users, users.page(params[:page]), with: API::V1::Entities::UserEntity, only: [:id, :fullname]
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
           end
        end

        desc "Invite Personel" do
          detail ' : send invitation email'
          named 'companies'
          headers token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          requires :email, type: String, regexp: /.+@.+/, allow_blank: false, desc: "Personnel email"
        end
        post '/invite_personnel' do
          if User.find_by(email: invitation_params[:email]).present?
            { status: "This user has belongs to one company" }
          else
            if User.invite!({email: invitation_params[:email], company_id: @company}, current_user)
              { status: "User Invited. Invitation email has sent." }
            else
              error_message
            end
          end
        end        

        desc "Company Agenda" do
          detail ' : schedules list in company (show)'
          params API::V1::Entities::ScheduleEntity.documentation
          named 'schedules'
          headers token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :pagination
        end
        get '/agenda' do

        end        

        desc "Applicant Report Filter Form" do
          detail ' : filter for form field'
          params API::V1::Entities::ScheduleEntity.documentation
          named 'schedules'
          headers token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        get '/report/filter' do
          
        end  

        desc "Applicant Report" do
          detail ' : filter process'
          params API::V1::Entities::ScheduleEntity.documentation
          named 'schedules'
          headers token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :pagination
          optional :by_period, type: Hash do
            optional :period,   type: String,       values: { value: ['week','month', 'year'], message: 'not valid' }, desc: "Per Period"
          end
          optional :by_stages, type: Hash do
            optional :stage, type: Array[String],  values: { value: Applicant::STATUSES.map{|key, val| key.to_s}, message: 'not valid' }, desc: "Applicant status" 
          end
          optional :by_jobs, type: Hash do
            optional :job,   type: Array[Integer], desc: "Job id" 
          end
          optional :by_consideration, type: Hash do
            optional :consideration,   type: Array[String], values: { value: ['qualified','disqualified'], message: 'not valid'}, desc: "Applicant consideration" 
          end
          optional :by_gender, type: Hash do
            optional :gender,   type: Array[String], values: { value: ['Male','Female'], message: 'not valid'}, desc: "Applicant gender" 
          end          
        end
        get '/report' do
            time = "#{params[:by_period][:period]}(applicants.created_at)"
            # byebug
            Applicant.join_job.filter_report_applicant(@company, params[:by_jobs][:job], params[:by_stages][:stage], params[:by_consideration][:consideration]).group(time).count
        end        

      end #end resource
    end
  end
end