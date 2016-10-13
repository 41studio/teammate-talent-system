module API
  module V1
  	module Entities
		extend Grape::API::Helpers
  		
  		class User < Grape::Entity
  			expose :first_name
  			expose :last_name
  			expose :email
  			expose :confirmed_at, format_with: :timestamp, as: :joined_at
  			expose :avatar
  		end
	  	
	  	class Applicant < Grape::Entity
			format_with :date do |date|
				date.strftime('%m/%d/%Y')
			end  			
	  		expose :id
	  		expose :name
	  		expose :gender
	  		expose :date_birth, format_with: :date
	  		expose :email
	  		expose :headline
	  		expose :phone
	  		expose :address
	  		expose :resume
	  		expose :status
  			expose :created_at, format_with: :timestamp, as: :apply_at
	  		expose :educations, using: "API::V1::Entities::Education", as: :educations 
	  		expose :experiences, using: "API::V1::Entities::Experience", as: :experiences 
			expose :comment_threads, using: "API::V1::Entities::Comment", as: :comments
	  		expose :photo
	  	end

	  	class Comment < Grape::Entity
	  		expose :fullname
	  		expose :body
	  	end

	  	class Education < Grape::Entity
	  		expose :id
	  		expose :name_school
	  		expose :field_study
	  		expose :degree
	  	end

	  	class Experience < Grape::Entity
	  		expose :id
	  		expose :name_company
	  		expose :industry
	  		expose :title
	  		expose :summary
	  	end

	  	class Job < Grape::Entity
	  		expose :id
	  		expose :job_title
	  		expose :departement
	  		expose :job_code
	  		expose :country
	  		expose :state
	  		expose :city
	  		expose :zip_code
	  		expose :min_salary
	  		expose :max_salary
	  		expose :curency
	  		expose :job_description
	  		expose :job_requirement
	  		expose :benefits
	  		expose :job_search_keyword
	  		expose :status
	  		expose :education_list, using: "API::V1::Entities::EducationList", as: :edu
	  		expose :employment_type_list, using: "API::V1::Entities::EmploymentTypeList"
	  		expose :experience_list, using: "API::V1::Entities::ExperienceList"
	  		expose :function_list, using: "API::V1::Entities::FunctionList"
	  		expose :industry_list, using: "API::V1::Entities::IndustryList"
			expose :created_at, format_with: :timestamp
			expose :updated_at, format_with: :timestamp
	  	end

	  	class EducationList < Grape::Entity
	  		expose :id
	  		expose :education
	  	end

	  	class EmploymentTypeList < Grape::Entity
	  		expose :id
	  		expose :employment_type
	  	end

	  	class ExperienceList < Grape::Entity
	  		expose :id
	  		expose :experience
	  	end

	  	class FunctionList < Grape::Entity
	  		expose :id
	  		expose :function
	  	end

	  	class IndustryList < Grape::Entity
	  		expose :id
	  		expose :industry
	  	end

	  	class Company < Grape::Entity
	  		expose :company_name	
	  		expose :company_website
	  		expose :company_email
	  		expose :company_phone
	  		expose :industry
	  		expose :photo_company
	  	end

	  end
	end
end