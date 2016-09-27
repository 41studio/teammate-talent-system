class ScheduleMailer < ApplicationMailer
  	def notify_applicant_email(email, applicant, subject, date)
		mail(to: @email, subject: "Nama Aplikasi - #{@subject}")

		@email = email
		@applicant = applicant
		@subject = subject
		@date = date
		mail(to: @email, subject: @subject)
	end

end
