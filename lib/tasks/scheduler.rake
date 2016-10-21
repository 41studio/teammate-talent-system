desc "This task is called by the Heroku scheduler add-on"

task :notify_applicants => :environment do
	puts "Notify To Applicants..."
	date_1 = (DateTime.tomorrow)
	date_2 = (DateTime.tomorrow + 1.day) - 1.second
	schedules = Schedule.where('start_date BETWEEN ? AND ?', date_1, date_2)

	schedules.each do |schedule|
		applicant = schedule.applicant
		ScheduleMailer.delay.notify_applicant_email(applicant, schedule).deliver
	end
	puts "Done! "
end