# == Schema Information
#
# Table name: education_lists
#
#  id        :integer          not null, primary key
#  education :string(255)
#

class EducationList < ActiveRecord::Base
	belongs_to :job
end
