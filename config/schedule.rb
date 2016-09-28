# set :environment, Rails.env
# env :PATH, ENV['PATH']

set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}

every :day, :at => '09:00 am' do
	rake "notify_applicants"
end

# /bin/bash -c 'cd /home/kiki/Rails\ Exercises/teammate-talent-system && RAILS_ENV=development bundle exec rake notify_applicants'
# whenever --set environment=development --update-crontab
