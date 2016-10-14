module API
  module V1
    class Companies < Grape::API
      version 'v1' 
      format :json 
      before { authenticate! }

      helpers do
        def company_params
          company_param = ActionController::Parameters.new(params).require(:companies).permit(:company_name, :company_website, :company_email, :company_phone, :industry, photo_company: [:filename, :type, :name, :tempfile, :head])
          company_param["photo_company"] = ActionDispatch::Http::UploadedFile.new(params.companies.photo_company) if params.companies.photo_company.present? 
          company_param
        end

        def company
          current_user.company
        end

        def error_message
          error!({ status: :error, message: company.errors.full_messages.first }) if company.errors.any?
        end

        def field_on_company_form
          industry_list = IndustryList.all
          present :industry_list, industry_list, with: API::V1::Entities::IndustryList, only: [:industry]
        end     

        params :companies do
          requires :company_name, type: String, allow_blank: false
          requires :company_website, type: String, allow_blank: false
          requires :company_email, type: String, allow_blank: false
          requires :company_phone, type: String, allow_blank: false
          requires :industry, type: String, allow_blank: false
        end
      end      

      resource :companies do
        desc "Company detail", {
          :notes => <<-NOTE
          Company detail by User company (show)
          -------------------------------------
          NOTE
        } 
        get '/detail' do
          begin
            company.present? ? API::V1::Entities::Company.represent(company) : "Create company profil"
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
           end
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

        desc "Create Company", {
          :notes => <<-NOTE
          Create user company / save process (create)
          -------------------------------------------
          NOTE
        }
        params do
          requires :companies, type: Hash do
            use :companies
            requires :photo_company, type: File, allow_blank: false
          end
        end
        post '/create' do
          if company
            { status: :you_are_belongs_to_one_company }
          else
            companies = Company.create(company_params)
            if companies.save!
              current_user.update_attribute(:company_id, companies.id)
              { status: :success }
            else
              error_message
            end
          end
        end   

        desc "Company detail for edit", {
          :notes => <<-NOTE
          Company detail by User company (edit)
          -------------------------------------
          NOTE
        } 
        get '/edit' do
          begin
            field_on_company_form
            present :company, company, with: API::V1::Entities::Company
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
           end
        end

        desc "Update Company", {
          :notes => <<-NOTE
          Create user company
          -------------------
          NOTE
        }
        params do
          requires :companies, type: Hash do
            use :companies
            optional :photo_company, type: File
          end
        end
        put '/update' do
          if company
            if company.update(company_params)
              { status: :success }
            else
              error_message
            end
          else
            record_not_found_message
          end
        end 
      end #end resource
    end
  end
end