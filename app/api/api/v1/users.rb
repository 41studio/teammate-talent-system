module API
  module V1
    class Users < Grape::API
      version 'v1'
      format :json

      helpers do

      end

      resource :users do
        desc "User By token", {
          :notes => <<-NOTE
          Get User By token
          -------------------
          NOTE
        }
        params do
          requires :email        ,type: String, desc: "User email"
          requires :password        ,type: String, desc: "User password"
        end

        get do
          begin
            user = User.find_for_authentication(:email => params[:email])
            user.valid_password?(params[:password]) ? user : nil

          rescue ActiveRecord::RecordNotFound
            error!({status: :not_found}, 404)
           end
        end

      end #end resource
    end
  end
end
