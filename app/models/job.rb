class Job < ActiveRecord::Base
	has_many :applicants, dependent: :destroy
	belongs_to :company
	has_one :education_list
	has_one :employment_type_list
	has_one :experience_list
	has_one :function_list
	has_one :industry_list
	validates :job_title, :departement, :job_code, :country, :state, :city, :zip_code, :min_salary, :max_salary, :curency, :job_description, :job_requirement, :benefits, :experience_list_id, :function_list_id, :employment_type_list_id, :industry_list_id, :education_list_id, :job_search_keyword,  presence: true
	validates :job_title, length: {in: 3..100}
	validates :job_description, :job_requirement, :benefits, length: {in: 100..500, message: 'Must be more than 100 and less than 500'}
	validates :min_salary, :max_salary, numericality: { greater_than_or_equal_to: 1 }
end
