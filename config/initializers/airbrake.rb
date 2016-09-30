Airbrake.configure do |config|
  config.host = 'https://err-report.herokuapp.com'
  config.project_id = 1 # required, but any positive integer works
  config.project_key = 'a82962fd10064329816c0bcc8fac4ffa'

  # Uncomment for Rails apps
  config.environment = Rails.env
  config.ignore_environments = %w(development test)
end

if Rails.env.staging? || Rails.env.production?
  Airbrake.add_filter do |notice|
    if notice[:errors].any? { |error| error[:type] == 'ActiveRecord::RecordNotFound' || error[:type] =='ActionController::RoutingError' }
      notice.ignore!
    end
  end
end