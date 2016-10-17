class ScheduleMailer < ApplicationMailer
	
  	def notify_applicant_email(applicant, schedule)
		mail(to: @email, subject: "Nama Aplikasi - #{@subject}")

		@email = applicant.email
		@applicant = applicant.name
		@subject = "#{schedule.category}"
		@date = schedule.start_date.in_time_zone.to_date
	end

  	def update_notify_applicant_email(applicant, schedule)
		mail(to: @email, subject: "Nama Aplikasi - Update #{@subject} Schedule")

		@email = applicant.email
		@applicant = applicant.name
		@subject = "#{schedule.category}"
		@date = schedule.start_date.in_time_zone.to_date
	end

  	def canceled_notify_applicant_email(applicant, schedule)
		mail(to: @email, subject: "Nama Aplikasi - Canceled #{@subject} Schedule")

		@email = applicant.email
		@applicant = applicant.name
		@subject = "#{schedule.category}"
		@date = schedule.start_date.in_time_zone.to_date
	end
end
