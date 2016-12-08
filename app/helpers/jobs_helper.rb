# == Schema Information
#
# Table name: jobs
#
#  id                      :integer          not null, primary key
#  job_title               :string(255)      default(""), not null
#  departement             :string(255)      default(""), not null
#  job_code                :string(255)      default(""), not null
#  country                 :string(255)      default(""), not null
#  state                   :string(255)      default(""), not null
#  city                    :string(255)      default(""), not null
#  zip_code                :string(255)      default(""), not null
#  min_salary              :integer          default(0), not null
#  max_salary              :integer          default(0), not null
#  curency                 :string(255)      default(""), not null
#  job_description         :text(65535)      not null
#  job_requirement         :text(65535)      not null
#  benefits                :text(65535)      not null
#  job_search_keyword      :string(255)      default(""), not null
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

module JobsHelper
end
