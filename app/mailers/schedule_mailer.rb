class ScheduleMailer < ApplicationMailer
	
	after_action :update_applicant!, only: [:notify_applicant_email]

  def notify_applicant_email(applicant, schedule)
		mail(to: @email, subject: "Nama Aplikasi - #{@subject}")
		@schedule = schedule
		@email = applicant.email
		@applicant_name = applicant.name
		@subject = "#{schedule.category} Schedule"
		@date = @schedule.start_date
		# mail(to: @email, subject: @subject)
	end

  def update_notify_applicant_email(applicant, schedule)
		mail(to: @email, subject: "Nama Aplikasi - Update #{@subject} Schedule")
		@schedule = schedule
		@email = applicant.email
		@applicant_name = applicant.name
		@subject = "#{schedule.category} Schedule"
		@date = @schedule.start_date
		mail(to: @email, subject: @subject)
	end

  def canceled_notify_applicant_email(applicant, schedule)
		mail(to: @email, subject: "Nama Aplikasi - Canceled #{@subject} Schedule")
		@schedule = schedule
		@email = applicant.email
		@applicant_name = applicant.name
		@subject = "#{schedule.category}"
		@date = @schedule.start_date
		mail(to: @email, subject: @subject)
	end

	private
		def update_applicant!
			@schedule.update_column(:notify_applicant_flag, true)
		end
end
