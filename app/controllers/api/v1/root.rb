require 'grape-swagger'

module API
  module V1
    class Root < Grape::API
			version 'v1', using: :header, vendor: 'teamhire'
      format  :json
      # error_formatter :json, API::V1::ErrorFormatter      

      helpers API::V1::Helpers
      mount API::V1::Jobs
      mount API::V1::Companies
      mount API::V1::Applicants
      mount API::V1::Users
      mount API::V1::Schedules
      mount API::V1::Comments
      
      # global exception handler, used for error notifications
      rescue_from :all do |e|
        raise e
        error_response(message: "Internal server error: #{e}", status: 500)
      end

      add_swagger_documentation \
        mount_path: 'v1/swagger_doc',
        api_version: 'v1',
        info: {
          title: "Api Documentation",
          description: "Documentation of teamhire's api version 1 for other platform dev"
        }   
    end
  end
end
