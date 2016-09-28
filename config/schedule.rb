env :PATH, ENV['PATH']
# env :GEM_PATH, ENV['GEM_PATH']
# set :environment, 'development'

set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}
every :day, :at => '09:00 am' do
	runner 'SchedulerApplicantWorker.notify_applicants'
end

every 1.minutes do
	rake "notify_applicants"
end

# /bin/bash -c 'cd /home/kiki/Rails\ Exercises/teammate-talent-system && RAILS_ENV=development bundle exec rake notify_applicants'
