class SchedulerApplicantWorker
	def self.notify_applicants	
		date_1 = (DateTime.tomorrow)
		date_2 = (DateTime.tomorrow + 1.day) - 1.second
		schedules = Schedule.where('date BETWEEN ? AND ?', date_1, date_2)
	
		schedules.each do |schedule|
			applicant = schedule.applicant
			ScheduleMailer.notify_applicant_email(applicant.email, applicant.name, schedule.category, schedule.date).deliver
		end
	end
end

