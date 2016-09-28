class Job < ActiveRecord::Base
	has_many :applicants, dependent: :destroy
	belongs_to :company
	has_one :education_list
	has_one :employment_type_list
	has_one :experience_list
	has_one :function_list
	has_one :industry_list
	validates :job_title, :departement, :job_code, :country, :state, :city, :zip_code,
		:min_salary, :max_salary, :curency, :job_description, :job_requirement, :benefits,
		:experience_list_id, :function_list_id, :employment_type_list_id, :industry_list_id, 
		:education_list_id, :job_search_keyword,  presence: true
	validates :job_title, length: {in: 3..100}
	validates :job_description, :job_requirement, :benefits, 
	length: {in: 100..500, message: 'Must be more than 100 character and less than 500 character'}
	validates :min_salary, :max_salary, numericality: { greater_than_or_equal_to: 1 }
	validate :salary_regulation, :experience_collection_validation,:function_collection_validation,
		:employment_type_collection_validation,:industry_collection_validation,:education_collection_validation

	def applicants_count
		applicants.count
	end
	
	def applied_count
		applicants.where(status: "applied").count
	end

	def phone_screen_count
		applicants.where(status: "phone_screen").count
	end
	
	def interview_count
		applicants.where(status: "interview").count
	end
	
	def offer_count
		applicants.where(status: "offer").count
	end
	
	def hired_count
		applicants.where(status: "hired").count
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
	
	def self.search(search)
		where("status = \"published\" and (job_title LIKE ? OR job_search_keyword LIKE ?)", "%#{search}%", "%#{search}%")
	end
end
