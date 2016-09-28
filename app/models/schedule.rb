class Schedule < ActiveRecord::Base
	belongs_to :applicant

	validates_presence_of :date, :category

	after_create :send_notify_applicant_email
	after_update :send_update_notify_applicant_email

	private
		def date_schedule_check
			self.date == Date.tomorrow && (Time.now.hour >= 9 && Time.now.min > 0) 
		end

		def send_notify_applicant_email
			if date_schedule_check
		 		ScheduleMailer.notify_applicant_email(self.applicant.email, self.applicant.name, self.category, self.date).deliver
			end
		end

		def send_update_notify_applicant_email
			if date_schedule_check
				ScheduleMailer.update_notify_applicant_email(self.applicant.email, self.applicant.name, self.category, self.date).deliver
			end
		end
end
