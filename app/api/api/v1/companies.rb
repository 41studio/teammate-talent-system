module API
  module V1
    class Companies < Grape::API
      version 'v1' 
      format :json 
      before { authenticate! }

      helpers do
        def company_params
          ActionController::Parameters.new(params).require(:companies).permit(:company_name, :company_website, 
            :company_email, :company_phone, :industry, :photo_company)
        end

        def company
          current_user.company
        end

        def error_message
          error!({ status: :error, message: company.errors.full_messages.first }) if company.errors.any?
        end

        def field_on_company_form
          industry_list = IndustryList.all
          present :industry_list, industry_list, with: API::V1::Entities::IndustryList
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
            present company, with: API::V1::Entities::Company
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
          # requires :photo_company, :type => Rack::Multipart::UploadedFile, desc: "Company Photo"
          # requires :avatar, type: File
          # group :company, type: Array, desc: "An array of company" do
          #   requires :company_name, type: String
          #   requires :company_website, type: String
          #   requires :company_email, type: String
          #   requires :company_phone, type: String
          #   requires :industry, type: String
          #   requires :photo_company, type: File
          # end
          requires :companies, type: Array
        end
        post '/create' do
          # begin
            # companies = Company.create(company_params)
            if 1>2
              { status: :you_are_belongs_to_one_company }
            else
              # Company.create!({
              #   company_name: params[:company_name],
              #   company_website: params[:company_website],
              #   company_email: params[:company_email],
              #   company_phone: params[:company_phone],
              #   industry: params[:industry],
              #   photo_company: params[:photo_company]
              # })
              a = Company.create(company_params)
              # a.save!
            end
            # if companies.save!
            #   current_user.update_attribute(:company_id, companies.id)
            #   { status: :success }
            # else
            #   error_message
            # end

          # rescue ActiveRecord::RecordNotFound
          #   record_not_found_message
          # end 
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
        put '/update' do
          begin
            if company.update(company_params)
              { status: :success }
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