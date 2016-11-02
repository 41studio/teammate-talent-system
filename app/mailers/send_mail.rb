class SendMail < ApplicationMailer
	
	def send_email_to_applicant(applicant, subject, body)
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

	def self.send_email_to_company_after_applicant_applied(user_emails, job, applicant)
		emails = user_emails.map(&:email)
		emails << job.company.company_email
		emails.each do |email|
			delay.new_email_to_company_after_applicant_applied(email, job, applicant)
		end
	end

	def new_email_to_company_after_applicant_applied(email, job, applicant)
		@applicant = applicant
		@job = job
		mail(to: email, subject: 'New Applied Applicant')
	end
end