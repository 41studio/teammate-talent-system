desc "This task is called by the Heroku scheduler add-on"

task :notify_applicants => :environment do
	puts "Notify To Applicants..."
	SchedulerApplicantWorker.notify_applicants
	puts "Done! "
end