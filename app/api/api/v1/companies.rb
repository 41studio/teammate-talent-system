module API
  module V1
    class Companies < Grape::API
      version 'v1' 
      format :json 
 
      resource :companies do
        desc "Return list of companies"
        get do
          Company.all
        end

        desc "Return a company"
        params do
          requires :id, type: Integer, desc: "ID of the company"        
        end

        get ":id", root: "company" do
          Company.where(id: params[:id]).first!
        end
      end

    end
  end
end