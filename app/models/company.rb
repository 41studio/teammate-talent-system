# == Schema Information
#
# Table name: companies
#
#  id              :integer          not null, primary key
#  company_name    :string(255)
#  company_website :string(255)
#  company_email   :string(255)
#  company_phone   :string(255)
#  industry        :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  photo_company   :string(255)
#

class Company < ActiveRecord::Base
	has_many :jobs, dependent: :destroy
	has_many :applicants, through: :jobs
	has_many :schedules, through: :applicants
	has_many :users
	
	EMAIL_REGEX = /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info|co.id))\z/i
	mount_uploader :photo_company, PhotoCompanyUploader
	
	validates :company_name, :company_website, :company_email, :industry, presence: true
	validates :company_name, length: { in: 2..40 }
	validates :company_phone, numericality: true
  	# validates_processing_of :photo_company
    validates :company_email, presence: true, uniqueness: true, format: {with: EMAIL_REGEX}
	validate :image_size_validation


	def applicant_schedule
		applicant_schedules = {}
		jobs = {}
		applicants = {}
		schedules = {}

		self.jobs.each do |job|
			jobs["job#{job.id}".to_s] = job.job_title
			applicant_schedules[:jobs] = jobs
			job.applicants.each do |applicant|
				applicants["applicant#{applicant.id}".to_s] = applicant.name
				applicant_schedules[:applicants] = applicants
				applicant.schedules.each do |schedule|
					schedules["schedule#{schedule.id}".to_s] = "#{schedule.start_date.to_date} at #{schedule.start_date.strftime("%I:%M%p")}" 
				end
			end
			applicant_schedules[:schedules] = schedules
		end

		applicant_schedules
		# applicant_schedule = {job: job, {applicant: current_user, schedules: [current_user.company.jobs]}
	end

private
  def image_size_validation
    errors[:photo_company] << "should be less than 1.2MB" if photo_company.size > 1.2.megabytes
  end
end
