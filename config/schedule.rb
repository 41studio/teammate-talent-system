set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}
# runner "MyModel.task_to_run_at_four_thirty_in_the_morning"
every :day, :at => '11:40 am' do
runner 'SchedulerApplicantWorker.notify_applicants'
end