module API
  module V1
    class Companies < Grape::API
      version 'v1' 
      format :json 
      before { authenticate! }

      helpers do
        def company_params
          ActionController::Parameters.new(params).require(:company).permit(:company_name, :company_website, :company_email, :company_phone, :industry)
          # ActionController::Parameters.new(params).optional(:company).permit(:photo_company)
        end

        def company
          current_user.company
        end

        def error_message
          error!({ status: :error, message: company.errors.full_messages.first }) if company.errors.any?
        end
      end      

      resource :companies do
        desc "User By token", {
          :notes => <<-NOTE
          Get User By token
          -------------------
          NOTE
        } 
        get '/detail' do
          begin
            present company, with: API::V1::Entities::Company
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
           end
        end

        desc "Create Company", {
          :notes => <<-NOTE
          Create user company
          -------------------
          NOTE
        }
        post '/create' do
          begin
            companies = Company.create(company_params)
            if companies.save!
              current_user.update_attribute(:company_id, companies.id)
              { status: :success }
            else
              error_message
            end

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
        put '/edit' do
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