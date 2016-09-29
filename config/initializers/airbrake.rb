Airbrake.configure do |config|
  config.host = 'https://err-report.herokuapp.com'
  config.project_id = 1 # required, but any positive integer works
  config.project_key = 'a82962fd10064329816c0bcc8fac4ffa'

  # Uncomment for Rails apps
  config.environment = Rails.env
  config.ignore_environments = %w(development test)
end