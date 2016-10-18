# == Schema Information
#
# Table name: schedules
#
#  id                    :integer          not null, primary key
#  date                  :datetime         not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  applicant_id          :integer
#  category              :string(255)      not null
#  notify_applicant_flag :string(255)      default("false"), not null
#

class Schedule < ActiveRecord::Base
	belongs_to :applicant
	validates :start_date, :end_date, presence: true
	validate :time_exist
	validate :time_valid
	validate :start_date_valid

	after_create :send_notify_applicant_email
	after_update :send_update_notify_applicant_email
	after_destroy :send_canceled_notify_applicant_email

	private
		scope :by_company_id, -> (company_id, applicant_id) { self.joins(applicant: :job).where(jobs: {company_id: company_id}, applicants: {id: applicant_id}) }

		def time_collection
			time_now = Time.now.in_time_zone
			{
				min_time: time_now + 2.hours,
				time_now: time_now,
				date_now: time_now.to_date.to_date
			}
		end

		def time_exist
			# errors.add(:start_date, " is exist for this applicant")  if Schedule.where.not(start_date: self.start_date).include? applicant_schedule_date
		end

		def time_valid
			_time_collection = time_collection
			errors.add(:start_date, " cannot less than today ") if (applicant_schedule_date.to_date < _time_collection[:date_now])
			errors.add(:start_date, " cannot less than at #{_time_collection[:min_time].strftime('%I %P')}") if date_schedule_for_now && (applicant_schedule_date.hour < _time_collection[:min_time].hour)
		end

		def start_date_valid
			errors.add(:end_date, " cannot less than start date") if self.end_date < self.start_date
		end

		def applicant_total
			applicants.count	
		end

		def applicant_schedule_date
			self.start_date.in_time_zone
		end	

		def date_schedule_for_now
			_time_collection = time_collection
			applicant_schedule_date.to_date == _time_collection[:date_now]
		end

		def date_schedule_check
			_time_collection = time_collection
			applicant_schedule_date.to_date == Date.tomorrow.in_time_zone.to_date && (_time_collection[:time_now].hour >= 9 && _time_collection[:time_now].min > 0)
		end

		def send_notify_applicant_email
			if date_schedule_check 
		 		ScheduleMailer.delay.notify_applicant_email(self.applicant, self)
			end
		end

		def send_update_notify_applicant_email
			if date_schedule_check || (self.notify_applicant_flag == "true") 
				ScheduleMailer.delay.update_notify_applicant_email(self.applicant, self)
			end
		end

		def send_canceled_notify_applicant_email
			ScheduleMailer.delay.canceled_notify_applicant_email(self.applicant, self)
		end
end
