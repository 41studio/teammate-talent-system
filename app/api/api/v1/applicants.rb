module API
  module V1
    class Applicants < Grape::API
      version 'v1'
      format :json

      helpers do
        params :applicant_id do
          requires :id, type: Integer, desc: "Applicant id" 
        end
        params :job_id do
          requires :id, type: Integer, desc: " id" 
        end
      end

      resource :applicants do
        desc "Applicant By  Id", {
          :notes => <<-NOTE
          Get Applicant  By Id
          -----------------------
          NOTE
        }
        params do
          use :applicant_id       
        end
        get ":id" do
          begin
            Applicant.find(params[:id])
          rescue ActiveRecord::RecordNotFound
            error!({status: :not_found}, 404)
          end
        end


        desc "Update Status Applicant By Id", {
          :notes => <<-NOTE
          Update Applicant By Id
          --------------------
          NOTE
        }
        params do
          use :applicant_id
          requires :status        ,type: String, desc: "Applicant status"
        end
        put ':id' do
          authenticate!
          begin
            applicant = Applicant.find(params[:id])
            if applicant.update_attribute(:status, params[:status])
              { status: :success }
            else
              error!({ status: :error, message: applicant.errors.full_messages.first }) if applicant.errors.any?
            end
     
          rescue ActiveRecord::RecordNotFound
            error!({ status: :error, message: :not_found }, 404)
          end
        end

      end #end resource
    end
  end
end





