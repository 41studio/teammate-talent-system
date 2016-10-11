# == Schema Information
#
# Table name: experience_lists
#
#  id         :integer          not null, primary key
#  experience :string(255)
#

class ExperienceList < ActiveRecord::Base
	has_many :jobs
end
