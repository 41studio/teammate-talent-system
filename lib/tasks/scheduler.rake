desc "This task is called by the Heroku scheduler add-on"

task :notify_applicants => :environment do
	puts "Notify To Applicants..."
	date_1 = (DateTime.tomorrow)
	date_2 = (DateTime.tomorrow + 1.day) - 1.second
	schedules = Schedule.where('start_date BETWEEN ? AND ?', date_1, date_2)

	schedules.each do |schedule|
		applicant = schedule.applicant
		ScheduleMailer.notify_applicant_email(applicant.email, applicant.name, schedule.category, schedule.start_date).deliver
		schedule.applicant_notified!
	end
	puts "Done! "
end