module API
  module V1
    class Companies < Grape::API
      version 'v1' 
      format :json 
      before { authenticate! }

      helpers do
        def company_params
          ActionController::Parameters.new(params).require(:company).permit(:company_name, :company_website, :company_email, :company_phone, :industry, :photo_company)
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
          current_user.company

          rescue ActiveRecord::RecordNotFound
            error!({status: :not_found}, 404)
           end
        end

        desc "Create Company", {
          :notes => <<-NOTE
          Create user company
          -------------------
          NOTE
        }
        post '/new' do
          begin
            companies = Company.create(company_params)
            if companies.save!
              current_user.update_attribute(:company_id, companies.id)
              { status: :success }
            else
              error!({ status: :error, message: user.errors.full_messages.first }) if user.errors.any?
            end

          rescue ActiveRecord::RecordNotFound
            error!({status: :not_found}, 404)
          end 
        end       

      end #end resource
    end
  end
end