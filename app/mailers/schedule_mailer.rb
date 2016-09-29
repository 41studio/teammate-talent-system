class ScheduleMailer < ApplicationMailer
	
  	def notify_applicant_email(applicant, schedule)
		mail(to: @email, subject: "Nama Aplikasi - #{@subject}")

		@email = applicant.email
		@applicant = applicant.name
		@subject = schedule.category
		@date = schedule.date
		mail(to: @email, subject: @subject)
	end

  	def update_notify_applicant_email(applicant, schedule)
		mail(to: @email, subject: "Nama Aplikasi - Update #{@subject} Schedule")

		@email = applicant.email
		@applicant = applicant.name
		@subject = schedule.category
		@date = schedule.date
		mail(to: @email, subject: @subject)
	end
end
