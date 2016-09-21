module API
  module V1
    class Root < Grape::API
      error_formatter :json, API::V1::ErrorFormatter
    	
      mount API::V1::Jobs
      mount API::V1::Companies

    end
  end
end