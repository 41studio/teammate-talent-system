module API
  module V1
    class Jobs < Grape::API
      version 'v1'
      format :json
 
      resource :jobs do
        desc "Return list of jobs"
        get do
          Job.all
        end

        desc "Return a job"
        params do
          requires :id, type: Integer, desc: "ID of the job"        
        end

        get ":id", root: "job" do
          Job.where(id: params[:id]).first!
        end
      end

    end
  end
end