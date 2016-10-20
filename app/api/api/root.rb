module API
  class Root < Grape::API

    prefix	'api'
    format 	:json
    
    rescue_from :all, :backtrace => true
    error_formatter :json, API::ErrorFormatter

    helpers API::V1::Helpers
    mount API::V1::Root
    # mount API::V2::Root (next version)

  end
end