class SendMail < ApplicationMailer
	default from: "teamhiredev@gmail.com"

	def sample_email(applicant)
		@applicant = applicant
		mail(to: @applicant.email, subject: 'Thanks for applied this job')
	end
end