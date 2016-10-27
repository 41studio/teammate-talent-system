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
	alias_attribute :applicant_status, :status
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

	EMAIL_REGEX = /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info|co.id))\z/i

	validates :gender, :date_birth, :email, :phone, :address, :photo, :resume,  presence: true
	validates :name, length: {in: 2..70}
	# validates :gender, inclusion: { in: %w(Male Female), message: "%{value} is not a gender"}
	validates :phone, numericality: true
	validate :applicant_statuses
	validates_processing_of :photo
	validate :image_size_validation
	validates :email, presence: true, uniqueness: true, format: {with: EMAIL_REGEX}

	validates_processing_of :resume
	validate :resume_size_validation
	
	STATUSES = {"applied": 1,"phone_screen": 2,"interview": 3,"offer": 4,"hired": 5}
	DISQUALIFIED = "disqualified"

	paginates_per 10

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

	def self.filter_report_applicant(company_id, job_title, applicant_status, applicant_gender)
		where("jobs.company_id IN (?) and jobs.job_title IN (?) and applicants.status IN (?) and applicants.gender IN (?)", company_id, job_title, applicant_status, applicant_gender )
	end

	def self.filter_applicant(job_id, time, gender, status, job_title)
		joins(:job).where("applicants.job_id IN (?) and applicants.created_at >= ? and applicants.gender IN (?) 
        and applicants.status IN (?) and jobs.job_title IN (?)", job_id, time, gender, status, job_title)		
	end

	def self.join_job
		joins(:job)
	end

	def self.get_first_created_applicant
		order("created_at ASC LIMIT 1")
	end

	private
		scope :by_company_id, -> (company_id) { self.joins(:job).where(jobs: {company_id: company_id}) }
		scope :by_job_ids, -> (job_ids) { self.joins(:job, :schedules).where(jobs: {id: job_ids}).group(:id) }
		scope :get_applicant_ids, -> { self.ids }
		def applicant_statuses
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
