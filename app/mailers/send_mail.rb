class SendMail < ApplicationMailer
	default from: "teamhiredev@gmail.com"

	def sample_email(applicant, subject, body)
		@applicant = applicant
		@subject = subject
		@body = body
		mail(to: @applicant.email, subject: @subject)
	end
end