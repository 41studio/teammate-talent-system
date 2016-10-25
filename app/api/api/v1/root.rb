require 'grape-swagger'

module API
  module V1
    class Root < Grape::API
			version 'v1', using: :header, vendor: 'teamhire'
      
      error_formatter :json, API::V1::ErrorFormatter      

      mount API::V1::Jobs
      mount API::V1::Companies
      mount API::V1::Applicants
      mount API::V1::Users
      mount API::V1::Schedules

      add_swagger_documentation \
        mount_path: '/swagger_doc',
        add_version: true,
        doc_version: '0.0.1',
        hide_documentation_path: true,
        markdown: false,
        models: [
          API::V1::Entities::UserEntity,
          API::V1::Entities::ApplicantEntity
        ]
		  before do
		      header['Access-Control-Allow-Origin'] = '*'
		      header['Access-Control-Request-Method'] = '*'
		  end

    end
  end
end