# == Schema Information
#
# Table name: jobs
#
#  id                      :integer          not null, primary key
#  title               :string(255)      default(""), not null
#  departement             :string(255)      default(""), not null
#  code                :string(255)      default(""), not null
#  country                 :string(255)      default(""), not null
#  state                   :string(255)      default(""), not null
#  city                    :string(255)      default(""), not null
#  zip_code                :string(255)      default(""), not null
#  min_salary              :integer          default(0), not null
#  max_salary              :integer          default(0), not null
#  curency                 :string(255)      default(""), not null
#  description         :text(65535)      not null
#  requirement         :text(65535)      not null
#  benefits                :text(65535)      not null
#  search_keyword      :string(255)      default(""), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  company_id              :integer
#  education_list_id       :integer
#  employment_type_list_id :integer
#  experience_list_id      :integer
#  function_list_id        :integer
#  industry_list_id        :integer
#  status                  :string(255)
#

class Job < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
	alias_attribute :job_status, :status
	has_many :applicants, dependent: :destroy
	belongs_to :company
	belongs_to :education_list
	belongs_to :employment_type_list
	belongs_to :experience_list
	belongs_to :function_list
	belongs_to :industry_list
  	belongs_to :user
	alias_method :creator, :user
	
	validates :title, :departement, :code, :country, :state, :city, :zip_code,
		:min_salary, :max_salary, :curency, :description, :requirement, :benefits,
		:experience_list_id, :function_list_id, :employment_type_list_id, :industry_list_id, 
		:education_list_id, :search_keyword,  presence: true
	validates :title, length: {in: 3..100}
	validates :description, :requirement, :benefits, 
	length: {in: 100..500, message: 'Must be more than 100 character and less than 500 character'}
	validates :min_salary, :max_salary, numericality: { greater_than_or_equal_to: 1 }
	validate :salary_regulation, :experience_collection_validation,:function_collection_validation,
		:employment_type_collection_validation,:industry_collection_validation,:education_collection_validation
	before_save :title
	before_update :title

	ransack_alias :keyword, :job_title_or_job_search_keyword
	ransack_alias :company, :company_company_name
	ransack_alias :industry, :industry_list_industry

	paginates_per 10

	STATUSES = ["draft", "published", "closed"]

	scope :by_company_id, -> (company_id) { self.joins(:company, applicants: :schedules).where(companies: {id: company_id}).group(:id) }
	scope :get_job_ids, -> { self.ids }
	
	def applicants_count
		applicants.count
	end
	
	def applied_count
		applicants.where(status: "applied").size
	end

	def phone_screen_count
		applicants.where(status: "phone_screen").size
	end
	
	def interview_count
		applicants.where(status: "interview").size
	end
	
	def offer_count
		applicants.where(status: "offer").size
	end
	
	def hired_count
		applicants.where(status: "hired").size
	end

	def	get_experience_name
		ExperienceList.select(:experience).find(self.experience_list_id)
	end

	def	get_function_name
		FunctionList.select(:function).find(self.function_list_id)
	end

	def	get_employment_type_name
		EmploymentTypeList.select(:employment_type).find(self.employment_type_list_id)
	end

	def	get_industry_name
		IndustryList.select(:industry).find(self.industry_list_id)
	end

	def	get_education_name
		EducationList.select(:education).find(self.education_list_id)
	end

	def salary_regulation
		errors.add(:max_salary, " cannot less than min salary") if self.max_salary <= self.min_salary
	end

	def experience_collection_validation
		find_experience = ExperienceList.find_by(id: self.experience_list_id)
		errors.add(:experience_list_id, " wrong option") if find_experience.nil?
	end

	def function_collection_validation
		find_function = FunctionList.find_by(id: self.function_list_id)
		errors.add(:function_list_id, " wrong option") if find_function.nil?
	end

	def employment_type_collection_validation
		find_employment_type = EmploymentTypeList.find_by(id: self.employment_type_list_id)
		errors.add(:employment_type_list_id, " wrong option") if find_employment_type.nil?
	end

	def industry_collection_validation
		find_industry = IndustryList.find_by(id: self.industry_list_id)
		errors.add(:industry_list_id, " wrong option") if find_industry.nil?
	end

	def education_collection_validation
		find_education = EducationList.find_by(id: self.education_list_id)
		errors.add(:education_list_id, " wrong option") if find_education.nil?
	end

	def self.drafted_jobs
		where(status: "draft")
	end
	
	def self.published_jobs
		where(status: "published")
	end
	
	def self.closed_jobs
		where(status: "closed")
	end

	def self.published_and_closed_jobs
		where("jobs.status != \"draft\"")
	end
	
	# def self.title
	# 	self[:title].titleize
	# end
	
	def self.title
		select(:title)
	end

	def applicant_stage_per_job(attr)
		Job.find(attr).applicants.group(:status).count
	end

	def self.sort_job_by_updated_at
		order('jobs.updated_at DESC')
	end
end
