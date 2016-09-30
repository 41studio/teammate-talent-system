class Schedule < ActiveRecord::Base
	belongs_to :applicant
	validates_presence_of :date, :category
	validate :time_exist

	after_create :send_notify_applicant_email
	after_update :send_update_notify_applicant_email

	def applicant_notified!
		update_attribute(:notify_applicant_flag, true)
	end

	def time_exist
		errors.add(:date, " is exist for this applicant")  if Schedule.where.not(self).include?self.time
	end

	# def schedule_available
	# 	errors.add(:category, " schedule doesn't available for this applicant")  if self.applicant.schedules.count >= 3
	# end

	private
		def date_schedule_check
			self.date.in_time_zone.to_date == Date.tomorrow.in_time_zone.to_date && (Time.now.in_time_zone.hour >= 9 && Time.now.in_time_zone.min > 0) 
		end

		def send_notify_applicant_email
			if date_schedule_check
		 		ScheduleMailer.notify_applicant_email(self.applicant, self).deliver
				self.applicant_notified!
			end
		end

		def send_update_notify_applicant_email
			if date_schedule_check || (self.notify_applicant_flag == true)
				ScheduleMailer.update_notify_applicant_email(self.applicant, self).deliver
			end
		end
end
