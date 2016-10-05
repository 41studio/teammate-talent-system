module API
  module V1
    class Companies < Grape::API
      version 'v1' 
      format :json 
      before { authenticate! }

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
      end

    end
  end
end
