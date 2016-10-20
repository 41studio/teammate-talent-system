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

      add_swagger_documentation base_path: "/api",
                                api_version: 'v1',
                                hide_documentation_path: true,
                                markdown: false

		  before do
		      header['Access-Control-Allow-Origin'] = '*'
		      header['Access-Control-Request-Method'] = '*'
		  end

    end
  end
end