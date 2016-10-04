class Schedule < ActiveRecord::Base
	belongs_to :applicant
	validates_presence_of :date, :category
	validate :time_exist

	after_create :send_notify_applicant_email
	after_update :send_update_notify_applicant_email
	after_destroy :send_canceled_notify_applicant_email

	def time_exist
		errors.add(:date, " is exist for this applicant")  if Schedule.where.not(date: self.date).include?self.date
	end

	def applicant_total
		applicants.count	
	end

	private
		def date_schedule_check
			self.date.in_time_zone.to_date == Date.tomorrow.in_time_zone.to_date && (Time.now.in_time_zone.hour >= 9 && Time.now.in_time_zone.min > 0) 
		end

		def send_notify_applicant_email
			if date_schedule_check
		 		ScheduleMailer.notify_applicant_email(self.applicant, self).deliver
			end
		end

		def send_update_notify_applicant_email
			if date_schedule_check || (self.notify_applicant_flag == "true")
				ScheduleMailer.update_notify_applicant_email(self.applicant, self).deliver
			end
		end

		def send_canceled_notify_applicant_email
			ScheduleMailer.canceled_notify_applicant_email(self.applicant, self).deliver
		end
end
