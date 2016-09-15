class Job < ActiveRecord::Base
	has_many :applicants
	
	validates :job_title, :departement, :job_code, :country, :state, :city, :zip_code, :min_salary, :max_salary, :curency, :job_description, :job_requirement, :benefits, :aplicant_experience, :aplicant_function, :aplicant_employment_type, :aplicant_industry, :aplicant_education, :job_search_keyword,  presence: true
	validates :job_title, length: {in: 3..100}
	validates :job_description, :job_requirement, :benefits, length: {in: 100..500, message: 'Must be more than 100 and less than 500'}
	validates :min_salary, :max_salary, numericality: { greater_than_or_equal_to: 1 }

end
