class ScheduleMailer < ApplicationMailer
	
	after_action :update_applicant!

  def notify_applicant_email(applicant, schedule)
		@schedule = schedule
		@applicant = applicant

		@email = @applicant.email
		@name = @applicant.name
		@category = @schedule.category
		@date = @schedule.start_date

    mail(to: @email, subject: "Reminder #{@category.capitalize} Schedule")
	end

  def update_notify_applicant_email(applicant, schedule)
		@schedule = schedule
		@applicant = applicant

		@email = @applicant.email
		@name = @applicant.name
		@category = @schedule.category
		@date = @schedule.start_date

    mail(to: @email, subject: "Update #{@category.capitalize} Schedule")
	end

  def canceled_notify_applicant_email(applicant, schedule)
		@schedule = schedule
		@applicant = applicant

		@email = @applicant.email
		@name = @applicant.name
		@category = @schedule.category
		@date = @schedule.start_date

    mail(to: @email, subject: "Canceled #{@category.capitalize} Schedule")
	end

	private
		def update_applicant!
			@schedule.update_column(:notify_applicant_flag, true)
		end
end
