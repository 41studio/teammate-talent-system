module API
  module V1
    class Root < Grape::API
      mount API::V1::Jobs
      error_formatter :json, API::V1::ErrorFormatter
      mount API::V1::Companies
    end
  end
end