# == Schema Information
#
# Table name: education_lists
#
#  id        :integer          not null, primary key
#  education :string(255)
#

class EducationList < ActiveRecord::Base
	has_many :jobs
end
