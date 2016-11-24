# == Schema Information
#
# Table name: applicants
#
#  id         :integer          not null, primary key
#  name       :string(255)      default(""), not null
#  gender     :string(255)      default(""), not null
#  date_birth :date             not null
#  email      :string(255)      default(""), not null
#  headline   :string(255)      default(""), not null
#  phone      :string(255)      default(""), not null
#  address    :string(255)      default(""), not null
#  photo      :string(255)      default(""), not null
#  resume     :string(255)      default(""), not null
#  status     :string(255)      default("Applied"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  job_id     :integer
#

class Applicant < ActiveRecord::Base
	STATUSES = {"applied": 1,"phone_screen": 2,"interview": 3,"offer": 4,"hired": 5}
	DISQUALIFIED = "disqualified"
	PERIOD = ["week", "month", "year"]
	EMAIL_REGEX = /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info|co.id))\z/i

	acts_as_commentable
	
	belongs_to :job

	has_and_belongs_to_many :educations
	has_and_belongs_to_many :experiences
	
	has_many :schedules, dependent: :destroy
	has_many :comments

	accepts_nested_attributes_for :educations, :experiences

	before_destroy {|applicant| applicant.experiences.clear}
	before_destroy {|applicant| applicant.educations.clear}

	mount_uploader :photo, PhotoUploader
	mount_uploader :resume, ResumeUploader

	validates :gender, :date_birth, :headline, :address, :photo, :resume,  presence: true
	validates :name, presence: true, length: {in: 2..70}
	validates :phone, presence: true, length: {in: 10..16}
	# validates :gender, inclusion: { in: %w(Male Female), message: "%{value} is not a gender"}
	validates :phone, numericality: true
	validates :email, presence: true, uniqueness: true, format: {with: EMAIL_REGEX}
	validates_processing_of :photo
	# validate :applicant_statuses
	validate :image_size_validation

	validates_processing_of :resume
	validate :resume_size_validation

	paginates_per 10

	scope :by_company_id, -> (company_id) { self.joins(:job).where(jobs: {company_id: company_id}) }
	scope :by_job_ids, -> (job_ids) { self.joins(:job, :schedules).where(jobs: {id: job_ids}).group(:id) }
	scope :are_qualified, -> { self.where.not(status: DISQUALIFIED) }

	alias_attribute :applicant_status, :status
	
	delegate :company, to: :job, prefix: true

	def disable_level
		if self.status != "disqualified"
			STATUSES.select{|key, value| STATUSES[self.status.to_sym] >= value}.keys
		end
	end

	def self.total_applicant(company_id, job_id)
		joins(:job).where(jobs: {id: job_id, company_id: company_id})
	end

	def self.total_applicant_status(company_id, job_id, status)
		joins(:job).where(jobs: {id: job_id, company_id: company_id}, applicants: {status: status})
	end

	def self.filter_report_applicant(company_id, job_id, applicant_status, applicant_gender)
		where("jobs.company_id IN (?) and jobs.id IN (?) and applicants.status IN (?) and applicants.gender IN (?)", company_id, job_id, applicant_status, applicant_gender )
	end

	def self.filter_applicant(job_id_on_company, time, gender, status, job_id)
		joins(:job).where("applicants.job_id IN (?) and applicants.created_at >= ? and applicants.gender IN (?) 
        and applicants.status IN (?) and jobs.id IN (?)", job_id_on_company, time, gender, status, job_id)		
	end

	def self.join_job
		joins(:job)
	end

	def self.get_first_created_applicant
		order("created_at ASC LIMIT 1")
	end

	def self.applicant_statuses
    STATUSES.keys.map{|key| key.to_s}
	end

	def send_notification!(notice)
		notification = ApplicantPushNotification.new(self)
		notification.set_notice(notice)
		notification.push!
	end

	private
		def statuses
			if STATUSES.has_key? self.status.to_sym && self.status != DISQUALIFIED
				errors[:status] << "not available" 
				return false
			else
				return true
			end
		end

	  def image_size_validation
	    errors[:photo] << "should be less than 500KB" if photo.size > 0.5.megabytes
	  end

	  def resume_size_validation
	  	errors[:resume] << "should be less than 2MB" if resume.size > 2.megabytes
	  end
end
