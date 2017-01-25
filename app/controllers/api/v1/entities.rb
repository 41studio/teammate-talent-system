module API
  module V1
    module Entities
      class UserEntity < Grape::Entity
        expose :id
        expose :fullname
        expose :first_name
        expose :last_name
        expose :email
        expose :token
        expose :confirmed_at, format_with: :timestamp, as: :joined_at
        expose :avatar
      end
      
      class ApplicantEntity < Grape::Entity
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
        expose :status
        expose :address
        expose :created_at, format_with: :timestamp, as: :apply_at
        expose :resume
        expose :photo
        expose :educations, using: "API::V1::Entities::EducationEntity", as: :educations 
        expose :experiences, using: "API::V1::Entities::ExperienceEntity", as: :experiences
      end

      class CommentEntity < Grape::Entity
        expose :user, using: "API::V1::Entities::UserEntity"
        expose :body
        expose :created_at, format_with: :timestamp
      end

      class EducationEntity < Grape::Entity
        expose :id
        expose :name_school
        expose :field_study
        expose :degree
      end

      class ExperienceEntity < Grape::Entity
        expose :id
        expose :name_company
        expose :industry
        expose :title
        expose :summary
      end

      class JobEntity < Grape::Entity
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
        expose :education_list, using: "API::V1::Entities::EducationListEntity"
        expose :employment_type_list, using: "API::V1::Entities::EmploymentTypeListEntity"
        expose :experience_list, using: "API::V1::Entities::ExperienceListEntity"
        expose :function_list, using: "API::V1::Entities::FunctionListEntity"
        expose :industry_list, using: "API::V1::Entities::IndustryListEntity"
        expose :company, using: "API::V1::Entities::CompanyEntity"
      expose :created_at, format_with: :timestamp
      expose :updated_at, format_with: :timestamp
      end

      class EducationListEntity < Grape::Entity
        expose :id
        expose :education
      end

      class EmploymentTypeListEntity < Grape::Entity
        expose :id
        expose :employment_type
      end

      class ExperienceListEntity < Grape::Entity
        expose :id
        expose :experience
      end

      class FunctionListEntity < Grape::Entity
        expose :id
        expose :function
      end

      class IndustryListEntity < Grape::Entity
        expose :id
        expose :industry
      end

      class CompanyEntity < Grape::Entity
        expose :company_name  
        expose :company_website
        expose :company_email
        expose :company_phone
        expose :industry
        expose :photo_company
      end

      class ScheduleEntity < Grape::Entity
        expose :id
        expose :applicant, using: "API::V1::Entities::ApplicantEntity"
        expose :start_date, format_with: :timestamp
        expose :end_date, format_with: :timestamp
        expose :category
        expose :assignee, using: "API::V1::Entities::UserEntity"
        expose :notify_applicant_flag, as: :sent_email_to_applicant
        expose :category_valid

        private
          def category_valid
            Schedule::CATEGORY
          end
      end

    end
  end
end