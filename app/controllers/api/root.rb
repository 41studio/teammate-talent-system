module API
  class Root < Grape::API
  	mount API::V1::Root

    # supports foreign requests by enabling CORS
	  before do
	      header['Access-Control-Allow-Origin'] = '*'
	      header['Access-Control-Request-Method'] = '*'
	  end
    
  end
end
