# == Schema Information
#
# Table name: employment_type_lists
#
#  id              :integer          not null, primary key
#  employment_type :string(255)
#

class EmploymentTypeList < ActiveRecord::Base
	has_many :jobs
end
