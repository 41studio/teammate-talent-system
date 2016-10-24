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
	belongs_to :assignee, class_name: "User", foreign_key: :assignee_id
	validates :start_date, :end_date, :assignee_id, presence: true
	validate :time_exist
	validate :time_valid
	validate :avaliable_assignee
	validate :start_date_valid
	validate :category_valid
	# validate :schedule_date_is_valid_datetime

	after_create :send_notify_applicant_email
	after_update :send_update_notify_applicant_email
	before_update :set_email

	paginates_per 10

	CATEGORY = ['phone_screen','interview','offer']

	def notify_applicant_flag_display_text
		self.notify_applicant_flag ? 'Notified' : 'Waiting for due date'
	end

	def start_time
		self.start_date.to_datetime
	end

	def start_date_display
		self.start_date.to_formatted_s(:long) 
	end

	def end_date_display
		self.end_date.to_formatted_s(:long) 
	end

	def out_of_date
		_time_collection = time_collection
		applicant_schedule_date < _time_collection[:date_now]
	end

	# def date_format
	# 	self.strftime('%d %b %Y @ %I:%M%p')
	# end

	def send_canceled_notify_applicant_email
		ScheduleMailer.delay.canceled_notify_applicant_email(self.applicant, self)
		# ScheduleMailer.canceled_notify_applicant_email(self.applicant, self).deliver
	end

	private
		def time_collection
			time_now = Time.now.in_time_zone
			{
				min_time: time_now + 2.hours,
				time_now: time_now,
				date_now: time_now.to_date
			}
		end

		def old_schedules
			_time_collection = time_collection
			self.where("start_date < ?", _time_collection[:time_now])
		end

		def latest_schedules
			_time_collection = time_collection
			self.where.not("start_date < ?", _time_collection[:time_now]).order('start_date ASC')
		end

		scope :old_schedules, -> { self.where("start_date < ?", Time.now.in_time_zone) }
		scope :latest_schedules, -> { self.where.not("start_date < ?", Time.now.in_time_zone).order('start_date ASC') }
		scope :by_company_id, -> (company_id, applicant_id) { self.joins(applicant: :job).where(jobs: {company_id: company_id}, applicants: {id: applicant_id}) }


		def schedule_date_is_valid_datetime
			# DateTime.parse(start_date) && DateTime.parse(end_date) rescue errors.add(:start_date, ' and End date must be a valid datetime')
		end

		def assignee_valid
			errors.add(:assignee_id, " is not valid")  if User.joins(company: { jobs: :applicants }).where(applicants: { id: self.applicant_id }).find_by_id(self.assignee_id).present?
		end

		def avaliable_assignee
			errors.add(:assignee_id, " is exist for this time")  if Schedule.where(start_date: applicant_schedule_date, assignee_id: self.assignee_id).any? && self.start_date_changed?
		end

		def time_exist
			errors.add(:start_date, " is exist for this applicant")  if Schedule.where(start_date: self.start_date).any? && self.start_date_changed?
		end

		def time_valid
			_time_collection = time_collection
			errors.add(:start_date, " cannot less than today ") if (applicant_schedule_date.to_date < _time_collection[:date_now])
			errors.add(:start_date, " cannot less than at #{_time_collection[:min_time].strftime('%I %P')}") if date_schedule_for_now && (applicant_schedule_date.hour < _time_collection[:min_time].hour)
		end

		def start_date_valid
			errors.add(:end_date, " cannot less than start date") if self.end_date < self.start_date
		end

		def category_valid
			errors.add(:category, " is not valid ") unless CATEGORY.include? self.category
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

		def send_notify_applicant_email
	 		ScheduleMailer.delay.notify_applicant_email(self.applicant, self)
	 		# ScheduleMailer.notify_applicant_email(self.applicant, self).deliver
		end

		def send_update_notify_applicant_email
			if self.category_changed? || self.start_date_changed?
				ScheduleMailer.delay.update_notify_applicant_email(self.applicant, self, @old_category)
				# ScheduleMailer.update_notify_applicant_email(self.applicant, self, @old_category).deliver
			end
		end

		def set_email
			if self.category_changed?
				@old_category = self.category_was 
			else
				@old_category
			end
		end
end
