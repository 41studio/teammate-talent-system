class ApplicantStatusChanged < ApplicationMailer
	def send_mail_after_change_status(applicant, job)
		@applicant = applicant
		@job = job
    mail(to: @applicant.email, subject: 'Your status is changed! Congrats!')
	end
end
