class SendMail < ApplicationMailer
	
	def sample_email(applicant, subject, body)
		@applicant = applicant
		@subject = subject
		@body = body
		mail(to: @applicant.email, subject: @subject)
	end

	def send_email_after_apply(applicant, job)
		@applicant = applicant
		@job = job
    mail(to: @applicant.email, subject: 'Thanks for apply')
	end

	def send_mail_after_change_status(applicant, job)
		@applicant = applicant
		@job = job
    mail(to: @applicant.email, subject: 'Your status is changed! Congrats!')
	end	
end