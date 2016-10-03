# == Schema Information
#
# Table name: industry_lists
#
#  id       :integer          not null, primary key
#  industry :string(255)
#

class IndustryList < ActiveRecord::Base
	belongs_to :job
end
